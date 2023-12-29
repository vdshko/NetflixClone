//
//  HomeViewModel.swift
//  NetflixClone
//
//  Created by Vladyslav Shkodych on 06.12.2023.
//

import Foundation
import Combine

protocol HomeViewModel: AnyObject {

    var pagedModels: [HomeDataType: PagedModel<Cinema>] { get }
    var dataChangedSubject: PassthroughSubject<HomeDataType, Never> { get }

    func reloadData()
    func nextData(for dataTypes: HomeDataType...)
}

final class HomeViewModelImpl: HomeViewModel {

    // MARK: - Properties

    var pagedModels: [HomeDataType: PagedModel<Cinema>] { return model.pagedModels }
    var dataChangedSubject: PassthroughSubject<HomeDataType, Never> { return model.dataChangedSubject }

    private let model: HomeModel

    // MARK: - Initializer

    init(model: HomeModel) {
        self.model = model
    }

    // MARK: - Methods

    func reloadData() {
        model.reloadData()
    }

    func nextData(for dataTypes: HomeDataType...) {
        model.nextData(for: dataTypes)
    }
}
