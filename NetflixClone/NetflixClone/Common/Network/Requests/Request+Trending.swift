//
//  Request+Trending.swift
//  NetflixClone
//
//  Created by Vladyslav Shkodych on 21.12.2023.
//

import Foundation

extension Requests {

    enum Trending {}
}

extension Requests.Trending {

    static func movie(networkManager: NetworkManager) {
        let path: String = "trending/movie/week"
        let networkRequest: NetworkRequest = URLRequestBuilder(with: path)
            .add(httpMethod: .get)
            .addDefaultAuthorizableKey()
            .add(urlParameters: ["language": "en-US"])
            .build()
        networkManager.makeRequest(for: networkRequest)
    }
}
