//
//  CollectionViewTableViewCell.swift
//  NetflixClone
//
//  Created by Vladyslav Shkodych on 06.12.2023.
//

import UIKit

final class CollectionViewTableViewCell: UITableViewCell {

    // MARK: - UI

    private lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 140.0, height: 200.0)
        layout.scrollDirection = .horizontal
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self

        return collectionView
    }()

    // MARK: - Properties

    private var model: Model?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        configure()
    }

    // MARK: - Methods

    func setup(with model: Model) {
        self.model = model
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension CollectionViewTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model?.data.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: UICollectionViewCell = collectionView.cell(for: CellIdentifiers.default, in: indexPath)
        else { return UICollectionViewCell() }
        cell.contentView.backgroundColor = .systemBlue

        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CollectionViewTableViewCell: UICollectionViewDelegateFlowLayout {}

// MARK: - Private methods

private extension CollectionViewTableViewCell {

    func configure() {
        configureUI()
    }

    func configureUI() {
        contentView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
