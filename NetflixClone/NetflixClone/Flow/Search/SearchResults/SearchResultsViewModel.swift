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

    func reloadData()
    func nextData()
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

    func reloadData() {
        model.reloadData()
    }

    func nextData() {
        model.nextData()
    }
}
