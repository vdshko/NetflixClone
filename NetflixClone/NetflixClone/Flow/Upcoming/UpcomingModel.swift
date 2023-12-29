//
//  UpcomingModel.swift
//  NetflixClone
//
//  Created by Vladyslav Shkodych on 29.12.2023.
//

import Foundation
import Combine

protocol UpcomingModel: AnyObject {

    var pagedModel: PagedModel<Cinema> { get }
    var dataChangedSubject: PassthroughSubject<Void, Never> { get }

    func reloadData()
    func nextData()
}

final class UpcomingModelImpl: UpcomingModel {

    // MARK: - Properties

    @MainActor
    private(set) var pagedModel: PagedModel<Cinema> = PagedModel<Cinema>()

    let dataChangedSubject: PassthroughSubject<Void, Never> = PassthroughSubject()

    private let networkManager: NetworkManager

    // MARK: - Initializer

    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
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
}

// MARK: - Private methods

private extension UpcomingModelImpl {

    func updateData() {
        Task {
            async let model = MainActor.run { return pagedModel }
            let result: PagedResponse<Cinema> = await Requests.Movie.upcoming(networkManager: networkManager, pagedModel: model)
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
