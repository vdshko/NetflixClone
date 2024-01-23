//
//  DIContainer.swift
//  NetflixClone
//
//  Created by Vladyslav Shkodych on 23.01.2024.
//

import Foundation

final class DIContainer {
    
    let appState: AppState
    let networkManager: NetworkManager
    
    init(appState: AppState, networkManager: NetworkManager) {
        self.appState = appState
        self.networkManager = networkManager
    }
}
