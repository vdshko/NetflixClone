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
    var pagedModel: PagedModel<TrendingMovie> { get }

    var dataChangedCallback: () -> Void { get set }

    func updateData()
}

final class HomeModelImpl: HomeModel {

    // MARK: - Properties
    
    var dataChangedCallback: () -> Void = {}

    private(set) var data: [Int] = [Int](1...10)
    private(set) var sectionTitles: [String] = [
        String(localized: "home.section_title.trending_movies"),
        String(localized: "home.section_title.popular"),
        String(localized: "home.section_title.trending_tv"),
        String(localized: "home.section_title.upcoming_movies"),
        String(localized: "home.section_title.top_rated")
    ]
    private(set) var pagedModel: PagedModel<TrendingMovie> = PagedModel<TrendingMovie>()

    private let networkManager: NetworkManager

    // MARK: - Initializer

    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }

    // MARK: - Methods

    func updateData() {
        Task {
            let result: PagedResponse<TrendingMovie> = await Requests.Trending.movie(
                networkManager: networkManager,
                pagedModel: pagedModel
            )
            switch result {
            case .failure(let error): Logger.error(error)
            case .success(let newPagedModel):
                pagedModel.append(nextModel: newPagedModel)
                data = [Int](1...pagedModel.results.count)
                DispatchQueue.main.async { self.dataChangedCallback() }
            }
        }
    }
}
