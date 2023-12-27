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
        layout.scrollDirection = .horizontal
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        return collectionView
    }()

    // MARK: - Properties
    
    private var cellHorizontalInset: CGFloat = 20.0
    private var model: Model?

    // MARK: - Initializers

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
        guard let cell: CinemaCollectionViewCell = collectionView.cell(for: CellIdentifiers.cinema, in: indexPath),
              let data: Cinema = model?.data[indexPath.row]
        else { return UICollectionViewCell() }
        cell.setup(image: data.posterPath, title: data.originalTitle)

        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CollectionViewTableViewCell: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width: CGFloat = 140.0
        let height: CGFloat = width / 0.7
        
        return CGSize(width: width, height: height)
    }
}

// MARK: - Private methods

private extension CollectionViewTableViewCell {

    func configure() {
        configureUI()
    }

    func configureUI() {
        contentView.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
