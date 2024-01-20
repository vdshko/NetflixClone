//
//  NetworkManagerImpl.swift
//  NetflixClone
//
//  Created by Vladyslav Shkodych on 20.12.2023.
//

import Foundation

final class NetworkManagerImpl: NetworkManager {

    fileprivate init() {}

    private lazy var jsonDecoder: JSONDecoder = {
        let decoder: JSONDecoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let dateFormatter: DateFormatter = DateFormatter()
        if let timeZone: TimeZone = TimeZone(abbreviation: "UTC") {
            dateFormatter.timeZone = timeZone
        }
        dateFormatter.dateFormat = "yyyy-MM-dd"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        return decoder
    }()

    func makeRequest<T: Decodable>(for networkRequest: NetworkRequest) async -> Response<T> {
        do {
            let result: (data: Data, response: URLResponse) = try await URLSession.shared.data(for: networkRequest.urlRequest)
            let statusCode: Int? = (result.response as? HTTPURLResponse)?.statusCode
            switch statusCode {
            case 200: return .success(try jsonDecoder.decode(T.self, from: result.data))
            case 401: return .failure(NetworkManagerError.unauthorized)
            default: return .failure(NetworkManagerError.badResponse(statusCode: statusCode))
            }
        } catch {
            return .failure(NetworkManagerError.other(error))
        }
    }

    func makePagedRequest<T: Decodable>(for networkRequest: NetworkRequest) async -> PagedResponse<T> {
        do {
            let result: (data: Data, response: URLResponse) = try await URLSession.shared.data(for: networkRequest.urlRequest)
            let statusCode: Int? = (result.response as? HTTPURLResponse)?.statusCode
            switch statusCode {
            case 200: return .success(try jsonDecoder.decode(PagedModel<T>.self, from: result.data))
            case 401: return .failure(NetworkManagerError.unauthorized)
            default: return .failure(NetworkManagerError.badResponse(statusCode: statusCode))
            }
        } catch {
            return .failure(NetworkManagerError.other(error))
        }
    }
}

extension NetworkManagerFactoryImpl {

    func createNetworkManager() -> NetworkManager {
        return NetworkManagerImpl()
    }
}
