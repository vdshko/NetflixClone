//
//  NetworkManager.swift
//  NetflixClone
//
//  Created by Vladyslav Shkodych on 20.12.2023.
//

import Foundation

protocol NetworkManager: AnyObject {

    func makeRequest(for networkRequest: NetworkRequest)
}
