//
//  NetworkManagerError.swift
//  NetflixClone
//
//  Created by Vladyslav Shkodych on 22.12.2023.
//

import Foundation

enum NetworkManagerError: Error {

    case badURL
    case badRequest
    case badResponse(statusCode: Int? = nil)
    case unauthorized
    case other(Error)
}
