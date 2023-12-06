//
//  UITableViewExtensions.swift
//  NetflixClone
//
//  Created by Vladyslav Shkodych on 06.12.2023.
//

import UIKit

extension UITableView {

    func cell<T: UITableViewCell>(for identifier: String) -> T? {
        let cell: T? = dequeueReusableCell(withIdentifier: identifier) as? T
        guard cell == nil else { return cell }
        register(T.self, forCellReuseIdentifier: identifier)

        return dequeueReusableCell(withIdentifier: identifier) as? T
    }
}
