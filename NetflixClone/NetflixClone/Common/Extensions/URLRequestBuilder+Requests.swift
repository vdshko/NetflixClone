//
//  URLRequestBuilder+Requests.swift
//  NetflixClone
//
//  Created by Vladyslav Shkodych on 21.12.2023.
//

import Foundation

extension URLRequestBuilder {

    func addDefaultAuthorizableKey() -> Self {
        return add(urlParameters: ["api_key": Requests.Constants.API_KEY])
    }
}
