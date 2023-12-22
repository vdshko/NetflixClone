//
//  Requests.swift
//  NetflixClone
//
//  Created by Vladyslav Shkodych on 20.12.2023.
//

import Foundation

typealias Response<T: Decodable> = Result<T, NetworkManagerError>
typealias PagedResponse<T: Decodable> = Result<PagedModel<T>, NetworkManagerError>

/// An entry(core) point for all API requests.
enum Requests {

    enum Constants {

        static let API_KEY: String = "f33e6d3f9164d9655550054932d68a36"
        /// Due to the backend API restrictions.
        static let pageMaxCount: Int = 500
    }
}
