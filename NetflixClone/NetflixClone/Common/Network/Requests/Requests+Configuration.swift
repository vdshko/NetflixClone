//
//  Requests+Configuration.swift
//  NetflixClone
//
//  Created by Vladyslav Shkodych on 27.12.2023.
//

import Foundation

extension Requests {

    enum Configuration {}
}

extension Requests.Configuration {

    static func details(networkManager: NetworkManager) async -> Response<ConfigurationDetails> {
        let path: String = "configuration"
        let networkRequest: NetworkRequest = URLRequestBuilder(with: path)
            .add(httpMethod: .get)
            .addDefaultAuthorizableKey()
            .build()

        return await networkManager.makeRequest(for: networkRequest)
    }
}
