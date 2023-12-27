//
//  ConfigurationDetails.swift
//  NetflixClone
//
//  Created by Vladyslav Shkodych on 27.12.2023.
//

import Foundation

struct ConfigurationDetails: Decodable {

    let images: ConfigurationDetailsImages
}

extension ConfigurationDetails {

    init() {
        images = ConfigurationDetailsImages(secureBaseUrl: "")
    }
}

struct ConfigurationDetailsImages: Decodable {

    let secureBaseUrl: String
}
