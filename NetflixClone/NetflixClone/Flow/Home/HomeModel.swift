//
//  HomeModel.swift
//  NetflixClone
//
//  Created by Vladyslav Shkodych on 06.12.2023.
//

import Foundation

final class HomeModel {

    // MARK: - Properties
    
    var data: [Int] = [Int](1...10)
    var sectionTitles: [String] = [
        String(localized: "home.section_title.trending_movies"),
        String(localized: "home.section_title.popular"),
        String(localized: "home.section_title.trending_tv"),
        String(localized: "home.section_title.upcoming_movies"),
        String(localized: "home.section_title.top_rated")
    ]
}
