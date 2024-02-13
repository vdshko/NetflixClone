//
//  SearchResultsModel.swift
//  NetflixClone
//
//  Created by Vladyslav Shkodych on 20.01.2024.
//

import Foundation
import Combine

protocol SearchResultsModel: AnyObject {

    var pagedModel: PagedModel<Cinema> { get }
    var dataChangedSubject: PassthroughSubject<Void, Never> { get }

    func updateSearchQuery(with searchQuery: String)
    func reloadData()
    func nextData()
    func hideTabbar()
    func showTabbar()
}

final class SearchResultsModelImpl: SearchResultsModel {

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
    func updateSearchQuery(with searchQuery: String) {
        pagedModel = PagedModel()
        updateData(searchQuery: searchQuery)
    }

    @MainActor
    func reloadData() {
        pagedModel = PagedModel()
        updateData()
    }

    func nextData() {
        updateData()
    }

    func hideTabbar() {
        diContainer.appState.isTabBarHidden = true
    }

    func showTabbar() {
        diContainer.appState.isTabBarHidden = false
    }
}

// MARK: - Private methods

private extension SearchResultsModelImpl {

    func updateData(searchQuery: String = "") {
        Task {
            guard !searchQuery.isEmpty else { return }
            async let model = MainActor.run { return pagedModel }
            let result: PagedResponse<Cinema> = await Requests.Search.movies(networkManager: diContainer.networkManager, pagedModel: model, query: searchQuery)
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
