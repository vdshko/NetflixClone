//
//  HomeModel.swift
//  NetflixClone
//
//  Created by Vladyslav Shkodych on 06.12.2023.
//

import Foundation

protocol HomeModel: AnyObject {

    var pagedModels: [HomeDataType: PagedModel<Cinema>] { get }

    var dataChangedCallback: (HomeDataType) -> Void { get set }

    func reloadData()
    func nextData(for dataTypes: [HomeDataType])
}

final class HomeModelImpl: HomeModel {

    // MARK: - Properties

    var dataChangedCallback: (HomeDataType) -> Void = { _ in }

    @MainActor
    private(set) var pagedModels: [HomeDataType: PagedModel<Cinema>]

    private let networkManager: NetworkManager

    // MARK: - Initializer

    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
        self.pagedModels = HomeDataType.allCases.reduce(into: [HomeDataType: PagedModel<Cinema>]()) { $0[$1] = PagedModel<Cinema>() }
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
                case .movie: result = await Requests.Trending.movie(networkManager: networkManager, pagedModel: model)
                case .tv: result = await Requests.Trending.tv(networkManager: networkManager, pagedModel: model)
                }
            case .popular: result = await Requests.Movie.popular(networkManager: networkManager, pagedModel: model)
            case .upcoming: result = await Requests.Movie.upcoming(networkManager: networkManager, pagedModel: model)
            case .topRated: result = await Requests.Movie.topRated(networkManager: networkManager, pagedModel: model)
            }
            await handleUpdates(result, for: dataType)
        }
    }

    @MainActor
    func handleUpdates(_ result: PagedResponse<Cinema>, for dataType: HomeDataType) {
        switch result {
        case .failure(let error): Logger.error(error)
        case .success(let newPagedModel):
            if newPagedModel.page == 1 {
                pagedModels[dataType]?.update(newModel: newPagedModel)
            } else {
                pagedModels[dataType]?.append(nextModel: newPagedModel)
            }
            dataChangedCallback(dataType)
        }
    }
}
