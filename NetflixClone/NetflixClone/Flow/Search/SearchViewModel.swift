//
//  SearchViewModel.swift
//  NetflixClone
//
//  Created by Vladyslav Shkodych on 30.12.2023.
//

import Foundation
import Combine

protocol SearchViewModel: AnyObject {

    var pagedModel: PagedModel<Cinema> { get }
    var dataChangedSubject: PassthroughSubject<Void, Never> { get }

    func reloadData()
    func nextData()
}

final class SearchViewModelImpl: SearchViewModel {

    // MARK: - Properties

    var pagedModel: PagedModel<Cinema> { return model.pagedModel }
    var dataChangedSubject: PassthroughSubject<Void, Never> { return model.dataChangedSubject }

    private let model: SearchModel

    // MARK: - Initializer

    init(model: SearchModel) {
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
