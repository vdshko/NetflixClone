//
//  CellIdentifiers.swift
//  NetflixClone
//
//  Created by Vladyslav Shkodych on 05.12.2023.
//

import Foundation

/// UITableView and UICollectionView cells identifiers access point.
enum CellIdentifiers {

    static let `default`: String = "DefaultCell"
    static let collection: String = String(describing: CollectionViewTableViewCell.self)
    static let cinema: String = String(describing: CinemaCollectionViewCell.self)
}
