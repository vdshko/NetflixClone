//
//  SearchModel.swift
//  NetflixClone
//
//  Created by Vladyslav Shkodych on 30.12.2023.
//

import Foundation
import Combine

protocol SearchModel: AnyObject {

    var pagedModel: PagedModel<Cinema> { get }
    var dataChangedSubject: PassthroughSubject<Void, Never> { get }

    func reloadData()
    func nextData()
    func createSearchResultsModel() -> SearchResultsModel
}

final class SearchModelImpl: SearchModel {

    // MARK: - Properties

    @MainActor
    private(set) var pagedModel: PagedModel<Cinema> = PagedModel<Cinema>()

    let dataChangedSubject: PassthroughSubject<Void, Never> = PassthroughSubject()

    private let diContainer: DIContainer

    // MARK: - Initializer

    init(diContainer: DIContainer) {
        self.diContainer = diContainer
    }

    // MARK: - Methods

    @MainActor
    func reloadData() {
        pagedModel = PagedModel()
        updateData()
    }

    func nextData() {
        updateData()
    }

    func createSearchResultsModel() -> SearchResultsModel {
        return SearchResultsModelImpl(diContainer: diContainer)
    }
}

// MARK: - Private methods

private extension SearchModelImpl {

    func updateData() {
        Task {
            async let model = MainActor.run { return pagedModel }
            let result: PagedResponse<Cinema> = await Requests.Discover.movies(networkManager: diContainer.networkManager, pagedModel: model)
            await MainActor.run {
                switch result {
                case .failure(let error): Logger.error(error)
                case .success(let newPagedModel):
                    pagedModel.setup(with: newPagedModel)
                    dataChangedSubject.send(())
                }
            }
        }
    }
}
