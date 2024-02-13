//
//  Requests+Search.swift
//  NetflixClone
//
//  Created by Vladyslav Shkodych on 14.02.2024.
//

import Foundation

extension Requests {

    enum Search {}
}

extension Requests.Search {

    static func movies(
        networkManager: NetworkManager,
        pagedModel: PagedModel<Cinema>,
        query: String
    ) async -> PagedResponse<Cinema> {
        let path: String = "search/movie"
        let urlParameters: [String: String] = ["query": query]
        let networkRequest: NetworkRequest = URLRequestBuilder(with: path)
            .add(httpMethod: .get)
            .addDefaultAuthorizableKey()
            .add(urlParameters: urlParameters)
            .add(pagedModel: pagedModel)
            .build()

        return await networkManager.makePagedRequest(for: networkRequest)
    }
}
