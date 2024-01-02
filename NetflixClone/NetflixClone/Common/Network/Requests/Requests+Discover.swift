//
//  Requests+Discover.swift
//  NetflixClone
//
//  Created by Vladyslav Shkodych on 30.12.2023.
//

import Foundation

extension Requests {

    enum Discover {}
}

extension Requests.Discover {

    static func movies(networkManager: NetworkManager, pagedModel: PagedModel<Cinema>) async -> PagedResponse<Cinema> {
        let path: String = "discover/movie"
        let urlParameters: [String: String] = [
//            "language": "en-US",
//            "include_adult": "false",
//            "include_video": "false",
            "sort_by": "popularity.desc",
            "region": "UA"
        ]
        let networkRequest: NetworkRequest = URLRequestBuilder(with: path)
            .add(httpMethod: .get)
            .addDefaultAuthorizableKey()
            .add(urlParameters: urlParameters)
            .add(pagedModel: pagedModel)
            .build()

        return await networkManager.makePagedRequest(for: networkRequest)
    }
}
