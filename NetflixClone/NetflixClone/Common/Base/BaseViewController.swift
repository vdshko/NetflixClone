//
//  BaseViewController.swift
//  NetflixClone
//
//  Created by Vladyslav Shkodych on 20.12.2023.
//

import UIKit

class BaseViewController: UIViewController {

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable, message: "init(coder:) has not been implemented")
    required init?(coder: NSCoder) {
        fatalError("\(String(describing: Self.self)) init(coder:) - has not been implemented")
    }
}
