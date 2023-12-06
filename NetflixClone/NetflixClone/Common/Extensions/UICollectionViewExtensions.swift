//
//  UICollectionViewExtensions.swift
//  NetflixClone
//
//  Created by Vladyslav Shkodych on 06.12.2023.
//

import UIKit

extension UICollectionView {

    func cell<T: UICollectionViewCell>(for identifier: String, in indexPath: IndexPath) -> T? {
        register(T.self, forCellWithReuseIdentifier: identifier)
        
        return dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T
    }
}
