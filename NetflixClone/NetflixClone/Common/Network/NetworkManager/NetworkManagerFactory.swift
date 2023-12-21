//
//  NetworkManagerFactory.swift
//  NetflixClone
//
//  Created by Vladyslav Shkodych on 20.12.2023.
//

import Foundation

protocol NetworkManagerFactory: AnyObject {

    func createNetworkManager() -> NetworkManager
    
    func createNetworkManagerSpy() -> NetworkManager
}

final class NetworkManagerFactoryImpl: NetworkManagerFactory {

    func createNetworkManager() -> NetworkManager {
        return NetworkManagerImpl()
    }

    func createNetworkManagerSpy() -> NetworkManager {
        return NetworkManagerSpy()
    }
}
