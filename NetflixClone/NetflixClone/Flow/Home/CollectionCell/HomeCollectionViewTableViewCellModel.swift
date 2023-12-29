//
//  HomeCollectionViewTableViewCellModel.swift
//  NetflixClone
//
//  Created by Vladyslav Shkodych on 06.12.2023.
//

import Foundation

extension HomeCollectionViewTableViewCell {
    
    struct Model {
        
        let cinema: [Cinema]

        init(for cinema: [Cinema]) {
            self.cinema = cinema
        }
    }
}
