//
//  HomeViewModel.swift
//  NetflixClone
//
//  Created by Vladyslav Shkodych on 06.12.2023.
//

import Foundation

protocol HomeViewModel: AnyObject {

    var pagedModels: [HomeDataType: PagedModel<Cinema>] { get }

    var dataChangedCallback: (HomeDataType) -> Void { get set }

    func reloadData()
    func nextData(for dataTypes: HomeDataType...)
}

final class HomeViewModelImpl: HomeViewModel {

    // MARK: - Properties

    var dataChangedCallback: (HomeDataType) -> Void = { _ in }

    var pagedModels: [HomeDataType: PagedModel<Cinema>] { return model.pagedModels }

    private let model: HomeModel

    // MARK: - Initializer

    init(model: HomeModel) {
        self.model = model
        self.model.dataChangedCallback = { [weak self] in self?.dataChangedCallback($0) }
    }

    // MARK: - Methods

    func reloadData() {
        model.reloadData()
    }

    func nextData(for dataTypes: HomeDataType...) {
        model.nextData(for: dataTypes)
    }
}
