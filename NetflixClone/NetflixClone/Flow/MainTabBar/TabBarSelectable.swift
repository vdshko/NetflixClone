//
//  TabBarSelectable.swift
//  NetflixClone
//
//  Created by Vladyslav Shkodych on 23.12.2023.
//

import Foundation

protocol TabBarSelectable: AnyObject {

    func handleTabItemTap(isPreviouslySelected: Bool)
}
