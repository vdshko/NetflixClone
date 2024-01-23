//
//  HomeModel.swift
//  NetflixClone
//
//  Created by Vladyslav Shkodych on 06.12.2023.
//

import Foundation
import Combine

protocol HomeModel: AnyObject {

    var pagedModels: [HomeDataType: PagedModel<Cinema>] { get }
    var dataChangedSubject: PassthroughSubject<HomeDataType, Never> { get }

    func reloadData()
    func nextData(for dataTypes: [HomeDataType])
}

final class HomeModelImpl: HomeModel {

    // MARK: - Properties

    @MainActor
    private(set) var pagedModels: [HomeDataType: PagedModel<Cinema>]

    let dataChangedSubject: PassthroughSubject<HomeDataType, Never> = PassthroughSubject()

    private let diContainer: DIContainer

    // MARK: - Initializer

    init(diContainer: DIContainer) {
        self.diContainer = diContainer
        self.pagedModels = HomeDataType.allCases.reduce(into: [HomeDataType: PagedModel<Cinema>]()) {
            $0[$1] = PagedModel<Cinema>()
        }
    }

    // MARK: - Methods

    @MainActor
    func reloadData() {
        HomeDataType.allCases.forEach {
            pagedModels[$0] = PagedModel<Cinema>()
            updateData(for: $0)
        }
    }

    func nextData(for dataTypes: [HomeDataType]) {
        dataTypes.forEach { updateData(for: $0) }
    }
}

// MARK: - Private methods

private extension HomeModelImpl {

    func updateData(for dataType: HomeDataType) {
        Task {
            async let model = MainActor.run {
                return pagedModels[dataType] ?? PagedModel<Cinema>()
            }
            let result: PagedResponse<Cinema>
            switch dataType {
            case .trending(let mediaType):
                switch mediaType {
                case .movie: result = await Requests.Trending.movie(networkManager: diContainer.networkManager, pagedModel: model)
                case .tv: result = await Requests.Trending.tv(networkManager: diContainer.networkManager, pagedModel: model)
                }
            case .popular: result = await Requests.Movie.popular(networkManager: diContainer.networkManager, pagedModel: model)
            case .upcoming: result = await Requests.Movie.upcoming(networkManager: diContainer.networkManager, pagedModel: model)
            case .topRated: result = await Requests.Movie.topRated(networkManager: diContainer.networkManager, pagedModel: model)
            }
            await handleUpdates(result, for: dataType)
        }
    }

    @MainActor
    func handleUpdates(_ result: PagedResponse<Cinema>, for dataType: HomeDataType) {
        switch result {
        case .failure(let error): Logger.error(error)
        case .success(let newPagedModel):
            pagedModels[dataType]?.setup(with: newPagedModel)
            dataChangedSubject.send(dataType)
        }
    }
}
