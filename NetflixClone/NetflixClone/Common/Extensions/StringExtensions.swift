//
//  StringExtensions.swift
//  NetflixClone
//
//  Created by Vladyslav Shkodych on 20.12.2023.
//

import Foundation

extension String {

    /// A copy of the string with first word changed to its corresponding capitalized spelling.
    var capitalizedFirst: Self {
        guard !self.isEmpty else { return self }
        return self.dropLast(self.count - 1).uppercased() + self.dropFirst().lowercased()
    }
}
