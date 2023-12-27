//
//  NetworkManagerSpy.swift
//  NetflixClone
//
//  Created by Vladyslav Shkodych on 21.12.2023.
//

import Foundation

final class NetworkManagerSpy: NetworkManager {

    private(set) var _makeRequestCounter: Int = 0
    func makeRequest<T: Decodable>(for networkRequest: NetworkRequest) async -> Response<T> {
        _makeRequestCounter += 1
        return .success(ConfigurationDetails() as! T) //swiftlint:disable:this force_cast
    }

    private(set) var _makeRequestPagedCounter: Int = 0
    func makePagedRequest<T: Decodable>(for networkRequest: NetworkRequest) async -> PagedResponse<T> {
        _makeRequestPagedCounter += 1
        return .success(PagedModel())
    }
}
