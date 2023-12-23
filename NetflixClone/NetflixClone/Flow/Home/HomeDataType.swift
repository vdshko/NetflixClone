//
//  HomeDataType.swift
//  NetflixClone
//
//  Created by Vladyslav Shkodych on 22.12.2023.
//

import Foundation

enum HomeDataType: Hashable, CaseIterable {

    case trending(MediaType)
    case popular
    case upcoming
    case topRated

    var title: String {
        switch self {
        case .trending(let mediaType):
            switch mediaType {
            case .movie: return String(localized: "home.section_title.trending_movies")
            case .tv: return String(localized: "home.section_title.trending_tv")
            }
        case .popular: return String(localized: "home.section_title.popular")
        case .upcoming: return String(localized: "home.section_title.upcoming_movies")
        case .topRated: return String(localized: "home.section_title.top_rated")
        }
    }

    static var allCases: [HomeDataType] {
        return MediaType.allCases.map { .trending($0) } + [.popular, .upcoming, .topRated]
    }
}
