//
//  CinemaPosterCollectionViewCell.swift
//  NetflixClone
//
//  Created by Vladyslav Shkodych on 26.12.2023.
//

import UIKit
import Kingfisher

final class CinemaPosterCollectionViewCell: UICollectionViewCell {

    // MARK: - UI

    private let imageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()

    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overrides
    
    override func prepareForReuse() {
        super.prepareForReuse()

        imageView.kf.cancelDownloadTask()
        imageView.image = nil
    }

    // MARK: - Methods

    func setup(image path: String?) {
        imageView.kf.setImage(for: path)
    }
}

// MARK: - Private methods

private extension CinemaPosterCollectionViewCell {

    func configure() {
        contentView.layer.cornerRadius = Constants.Layout.cornerRadius
        contentView.clipsToBounds = true
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
