//
//  PublisherExtensions.swift
//  NetflixClone
//
//  Created by Vladyslav Shkodych on 29.12.2023.
//

import Combine

extension Publisher where Self.Failure == Never {

    func assignWeak<Root: AnyObject>(to keyPath: ReferenceWritableKeyPath<Root, Self.Output>, on object: Root) -> AnyCancellable {
        return sink { [weak object] (value: Self.Output) in
            object?[keyPath: keyPath] = value
        }
    }
}
