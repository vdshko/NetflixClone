//
//  HomeViewModel.swift
//  NetflixClone
//
//  Created by Vladyslav Shkodych on 06.12.2023.
//

import Foundation

protocol HomeViewModel: AnyObject {

    var data: [Int] { get }
    var sectionTitles: [String] { get }

    func updateData()
}

final class HomeViewModelImpl: HomeViewModel {

    // MARK: - Properties

    var data: [Int] { return model.data }
    var sectionTitles: [String] { return model.sectionTitles }

    private let model: HomeModel

    // MARK: - Initializer

    init(model: HomeModel) {
        self.model = model
    }

    // MARK: - Methods
    
    func updateData() {
        model.updateData()
    }
}
