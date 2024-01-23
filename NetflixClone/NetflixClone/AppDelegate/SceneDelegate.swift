//
//  SceneDelegate.swift
//  NetflixClone
//
//  Created by Vladyslav Shkodych on 05.12.2023.
//

import UIKit

final class SceneDelegate: UIResponder {

    var window: UIWindow?
}

// MARK: - UIWindowSceneDelegate

extension SceneDelegate: UIWindowSceneDelegate {

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        let networkManagerFactory: NetworkManagerFactory = NetworkManagerFactoryImpl()
        let networkManager: NetworkManager = networkManagerFactory.createNetworkManager()
        let diContainer: DIContainer = DIContainer(
            appState: AppState(),
            networkManager: networkManager
        )
        window?.rootViewController = MainTabBarController(diContainer: diContainer)
        window?.makeKeyAndVisible()
    }
}
