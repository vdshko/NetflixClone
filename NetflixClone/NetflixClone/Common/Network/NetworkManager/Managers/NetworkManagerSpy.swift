//
//  NetworkManagerSpy.swift
//  NetflixClone
//
//  Created by Vladyslav Shkodych on 21.12.2023.
//

import Foundation

final class NetworkManagerSpy: NetworkManager {

    private(set) var _makeRequestCounter: Int = 0
    func makeRequest(for networkRequest: NetworkRequest) {
        _makeRequestCounter += 1
    }
}
