//
//  URLRequestBuilder.swift
//  NetflixClone
//
//  Created by Vladyslav Shkodych on 21.12.2023.
//

import Foundation

final class URLRequestBuilder {

    private var urlParameters: [String: String] = [String: String]()
    private var jsonParameters: [String: Any] = [String: Any]()
    private var components: URLComponents
    private var base: URLRequest

    init(with path: String) {
        components = URLComponents()
        components.scheme = "https"
        components.host = "api.themoviedb.org"
        components.path = "/3/\(path)"
        guard let url: URL = components.url else {
            fatalError("\(String(describing: Self.self)) - Components have bad endpoint url")
        }

        base = URLRequest(url: url)
    }

    init(with baseURL: URL) {
        components = URLComponents()
        components.scheme = baseURL.scheme
        components.host = baseURL.host
        components.path = baseURL.path
        base = URLRequest(url: baseURL)
    }

    @discardableResult
    func add(headers: [String: String]) -> Self {
        let currentHeaders = base.allHTTPHeaderFields ?? [:]
        let updatedHeaders = headers.merging(currentHeaders, uniquingKeysWith: { $1 })
        base.allHTTPHeaderFields = updatedHeaders

        return self
    }

    func add(httpMethod: HTTPMethod) -> Self {
        base.httpMethod = httpMethod.rawValue

        return self
    }

    func add<T: Encodable>(body: T) -> Self {
        base.httpBody = try? JSONEncoder().encode(body)

        return self
    }

    func add(urlParameters: [String: String]) -> Self {
        urlParameters.forEach { key, value in
            self.urlParameters[key] = value
        }

        return self
    }

    func add(jsonParameters: [String: Any]) -> Self {
        jsonParameters.forEach { key, value in
            self.jsonParameters[key] = value
        }

        return self
    }

    func build() -> NetworkRequest {
        encode()
        add(headers: ["Accept": "application/json"])

        return NetworkRequestImp(urlRequest: base)
    }
}

// MARK: - Private methods

private extension URLRequestBuilder {

    func encode() {
        if !urlParameters.isEmpty {
            addUrlEncoding()
        }
        if !jsonParameters.isEmpty {
            addJsonEncoding()
        }
    }

    func addJsonEncoding() {
        do {
            base.httpBody = try JSONSerialization.data(withJSONObject: jsonParameters, options: [])
        } catch {
            fatalError("\(String(describing: Self.self)) - Can't encode body with error: \(error)")
        }
    }

    func addUrlEncoding() {
        components.queryItems = urlParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        guard let url: URL = components.url else { return }
        base.url = url
    }
}

// MARK: - NetworkRequest

protocol NetworkRequest: AnyObject {

    var urlRequest: URLRequest { get set }
}

final class NetworkRequestImp: NetworkRequest {

    var urlRequest: URLRequest

    fileprivate init(urlRequest: URLRequest) {
        self.urlRequest = urlRequest
    }
}
