//
//  HomeModel.swift
//  NetflixClone
//
//  Created by Vladyslav Shkodych on 06.12.2023.
//

import Foundation

protocol HomeModel: AnyObject {

    var data: [Int] { get }
    var sectionTitles: [String] { get }

    func updateData()
}

final class HomeModelImpl: HomeModel {

    // MARK: - Properties
    
    private(set) var data: [Int] = [Int](1...10)
    private(set) var sectionTitles: [String] = [
        String(localized: "home.section_title.trending_movies"),
        String(localized: "home.section_title.popular"),
        String(localized: "home.section_title.trending_tv"),
        String(localized: "home.section_title.upcoming_movies"),
        String(localized: "home.section_title.top_rated")
    ]

    private let networkManager: NetworkManager

    // MARK: - Initializer

    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }

    // MARK: - Methods

    func updateData() {
        Requests.Trending.movie(networkManager: networkManager)
    }
}
