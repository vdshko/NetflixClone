//
//  PagedModel.swift
//  NetflixClone
//
//  Created by Vladyslav Shkodych on 22.12.2023.
//

import Foundation

/// A model for the data pagination.
struct PagedModel<T: Decodable>: Decodable {

    var isFirstPage: Bool { return page == 1 }

    private(set) var page: Int
    private(set) var results: [T]

    mutating func setup(with model: PagedModel<T>) {
        if model.isFirstPage {
            update(newModel: model)
        } else {
            append(nextModel: model)
        }
    }

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
