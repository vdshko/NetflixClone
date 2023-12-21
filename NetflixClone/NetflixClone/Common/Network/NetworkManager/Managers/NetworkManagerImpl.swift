//
//  NetworkManagerImpl.swift
//  NetflixClone
//
//  Created by Vladyslav Shkodych on 20.12.2023.
//

import Foundation

final class NetworkManagerImpl: NetworkManager {

    func makeRequest(for networkRequest: NetworkRequest) {
        Task {
            do {
                let result = try await URLSession.shared.data(for: networkRequest.urlRequest)
                Logger.success("data:", result.0, "Status Code:", (result.1 as? HTTPURLResponse)?.statusCode ?? -1)
            } catch {
                Logger.error(error as Any)
            }
        }
    }
}
