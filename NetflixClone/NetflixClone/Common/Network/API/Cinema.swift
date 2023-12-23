//
//  Cinema.swift
//  NetflixClone
//
//  Created by Vladyslav Shkodych on 22.12.2023.
//

import Foundation

enum MediaType: String, CaseIterable, Codable {

    case movie
    case tv
}

struct Cinema: Codable {

    let id: Int
    let adult: Bool?
    let backdropPath: String?
    let originalTitle: String?
    let mediaType: MediaType?
    let genreIds: [Int]?
    let voteAverage: Double?
    let popularity: Double?
    let posterPath: String?
    let title: String?
    let overview: String?
    let originalLanguage: String?
    let voteCount: Int?
    let releaseDate: Date?
    let video: Bool?
}

extension Cinema {

    init() {
        self.id = 0
        self.adult = false
        self.backdropPath = "backdropPath"
        self.originalTitle = "originalTitle"
        self.mediaType = .movie
        self.genreIds = []
        self.voteAverage = 10.0
        self.popularity = 9.0
        self.posterPath = "posterPath"
        self.title = "title"
        self.overview = "overview"
        self.originalLanguage = "en"
        self.voteCount = 300
        self.releaseDate = Date()
        self.video = true
    }
}
