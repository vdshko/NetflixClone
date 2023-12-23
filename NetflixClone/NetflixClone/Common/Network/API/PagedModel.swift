//
//  PagedModel.swift
//  NetflixClone
//
//  Created by Vladyslav Shkodych on 22.12.2023.
//

import Foundation

/// A model for the data pagination.
struct PagedModel<T: Decodable>: Decodable {

    private(set) var page: Int
    private(set) var results: [T]

    mutating func update(newModel: PagedModel<T>) {
        page = newModel.page
        results = newModel.results
    }

    mutating func append(nextModel: PagedModel<T>) {
        guard nextModel.page > page else { return }
        page = nextModel.page
        results.append(contentsOf: nextModel.results)
    }
}

extension PagedModel {

    init() {
        page = 0
        results = []
    }
}
