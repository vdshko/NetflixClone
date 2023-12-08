//
//  UIApplicationExtensions.swift
//  NetflixClone
//
//  Created by Vladyslav Shkodych on 07.12.2023.
//

import UIKit

extension UIApplication {

    var activeWindow: UIWindow? {
        return connectedScenes
            .first { $0.activationState == UIScene.ActivationState.foregroundActive }
            .flatMap { $0 as? UIWindowScene }
            .flatMap { $0.windows.first }
    }

    var rootViewController: UIViewController? {
        return activeWindow?.rootViewController
    }
}
