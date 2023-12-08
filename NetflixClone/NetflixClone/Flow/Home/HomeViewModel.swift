//
//  HomeViewModel.swift
//  NetflixClone
//
//  Created by Vladyslav Shkodych on 06.12.2023.
//

import Foundation

final class HomeViewModel {

    // MARK: - Properties

    var data: [Int] { return model.data }

    private let model: HomeModel = HomeModel()
}
