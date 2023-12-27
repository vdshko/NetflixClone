//
//  Requests.swift
//  NetflixClone
//
//  Created by Vladyslav Shkodych on 20.12.2023.
//

import Foundation
import Combine

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

extension Requests.Constants {

    enum Images {

        static let baseUrlSubject: CurrentValueSubject<String, Never> = CurrentValueSubject("")

        static func updateBaseUrl(to newBaseUrl: String) {
            baseUrlSubject.send(newBaseUrl)
        }

        static func url(for path: String, size type: Self.ImagesSize = .original) -> URL? {
            return URL(string: [baseUrlSubject.value, type.rawValue, "/", path].joined())
        }
    }
}

extension Requests.Constants.Images {

    enum ImagesSize: String {

        case original
        case w500
    }
}
