//
//  NetworkManager.swift
//  NetflixClone
//
//  Created by Vladyslav Shkodych on 20.12.2023.
//

import Foundation

protocol NetworkManager: AnyObject {

    func makeRequest<T: Decodable>(for networkRequest: NetworkRequest) async -> Response<T>
    func makePagedRequest<T: Decodable>(for networkRequest: NetworkRequest) async -> PagedResponse<T>
}
