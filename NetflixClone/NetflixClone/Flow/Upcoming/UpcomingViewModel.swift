//
//  UpcomingViewModel.swift
//  NetflixClone
//
//  Created by Vladyslav Shkodych on 29.12.2023.
//

import Foundation
import Combine

protocol UpcomingViewModel: AnyObject {

    var pagedModel: PagedModel<Cinema> { get }
    var dataChangedSubject: PassthroughSubject<Void, Never> { get }

    func reloadData()
    func nextData()
}

final class UpcomingViewModelImpl: UpcomingViewModel {

    // MARK: - Properties

    var pagedModel: PagedModel<Cinema> { return model.pagedModel }
    var dataChangedSubject: PassthroughSubject<Void, Never> { return model.dataChangedSubject }

    private let model: UpcomingModel

    // MARK: - Initializer

    init(model: UpcomingModel) {
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
