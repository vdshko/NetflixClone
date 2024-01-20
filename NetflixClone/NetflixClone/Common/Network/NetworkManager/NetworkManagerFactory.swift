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

// Each NetworkManager implementation has a file-private initializer due to encapsulation.
// Protocol method realized in the NetworkManagerFactoryImpl extensions and placed into dedicated files.
final class NetworkManagerFactoryImpl: NetworkManagerFactory {}
