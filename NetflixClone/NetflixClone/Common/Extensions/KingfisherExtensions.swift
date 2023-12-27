//
//  KingfisherExtensions.swift
//  NetflixClone
//
//  Created by Vladyslav Shkodych on 27.12.2023.
//

import Kingfisher

extension KingfisherWrapper where Base: KFCrossPlatformImageView {

    func setImage(for path: String?) {
        guard let path else { return }
        setImage(with: Requests.Constants.Images.url(for: path, size: .w500))
    }
}
