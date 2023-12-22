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

    func add<T: Decodable>(pagedModel: PagedModel<T>) -> Self {
        let nextPageNumber: Int = min(Requests.Constants.pageMaxCount, max(1, pagedModel.page + 1))
        return add(urlParameters: ["page": "\(nextPageNumber)"])
    }
}
