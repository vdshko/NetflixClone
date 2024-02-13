//
//  SearchResultsViewModel.swift
//  NetflixClone
//
//  Created by Vladyslav Shkodych on 20.01.2024.
//

import Foundation
import Combine

protocol SearchResultsViewModel: AnyObject {

    var pagedModel: PagedModel<Cinema> { get }
    var dataChangedSubject: PassthroughSubject<Void, Never> { get }

    func updateSearchQuery(with searchQuery: String?)
    func reloadData()
    func nextData()
    func hideTabbar()
    func showTabbar()
}

final class SearchResultsViewModelImpl: SearchResultsViewModel {

    // MARK: - Properties

    var pagedModel: PagedModel<Cinema> { return model.pagedModel }
    var dataChangedSubject: PassthroughSubject<Void, Never> { return model.dataChangedSubject }

    private let model: SearchResultsModel

    // MARK: - Initializer

    init(model: SearchResultsModel) {
        self.model = model
    }

    // MARK: - Methods

    func updateSearchQuery(with searchQuery: String?) {
        guard let searchQuery, searchQuery.count >= 3 else { return }
        model.updateSearchQuery(with: searchQuery)
    }

    func reloadData() {
        model.reloadData()
    }

    func nextData() {
        model.nextData()
    }

    func hideTabbar() {
        model.hideTabbar()
    }

    func showTabbar() {
        model.showTabbar()
    }
}
