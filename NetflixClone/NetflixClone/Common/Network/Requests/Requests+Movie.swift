//
//  Requests+Movie.swift
//  NetflixClone
//
//  Created by Vladyslav Shkodych on 22.12.2023.
//

import Foundation

extension Requests {

    enum Movie {}
}

extension Requests.Movie {

    static func popular(networkManager: NetworkManager, pagedModel: PagedModel<Cinema>) async -> PagedResponse<Cinema> {
        let path: String = "movie/popular"
        let networkRequest: NetworkRequest = URLRequestBuilder(with: path)
            .add(httpMethod: .get)
            .addDefaultAuthorizableKey()
            .add(urlParameters: ["language": "en-US"])
            .add(pagedModel: pagedModel)
            .build()

        return await networkManager.makePagedRequest(for: networkRequest)
    }

    static func upcoming(networkManager: NetworkManager, pagedModel: PagedModel<Cinema>) async -> PagedResponse<Cinema> {
        let path: String = "movie/upcoming"
        let networkRequest: NetworkRequest = URLRequestBuilder(with: path)
            .add(httpMethod: .get)
            .addDefaultAuthorizableKey()
            .add(urlParameters: ["language": "en-US"])
            .add(pagedModel: pagedModel)
            .build()

        return await networkManager.makePagedRequest(for: networkRequest)
    }

    static func topRated(networkManager: NetworkManager, pagedModel: PagedModel<Cinema>) async -> PagedResponse<Cinema> {
        let path: String = "movie/top_rated"
        let networkRequest: NetworkRequest = URLRequestBuilder(with: path)
            .add(httpMethod: .get)
            .addDefaultAuthorizableKey()
            .add(urlParameters: ["language": "en-US"])
            .add(pagedModel: pagedModel)
            .build()

        return await networkManager.makePagedRequest(for: networkRequest)
    }
}
