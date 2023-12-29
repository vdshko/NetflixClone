//
//  SearchCinemaTableViewCell.swift
//  NetflixClone
//
//  Created by Vladyslav Shkodych on 30.12.2023.
//

import UIKit
import Kingfisher

final class SearchCinemaTableViewCell: UITableViewCell {

    // MARK: - UI

    private let cinemaImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = Constants.Layout.cornerRadius
        imageView.clipsToBounds = true

        return imageView
    }()

    private let titleLabel: UILabel = {
        let titleLabel: UILabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 3

        return titleLabel
    }()

    private let playButton: UIButton = {
        let playButton: UIButton = UIButton()
        let image: UIImage? = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30.0))
        playButton.setImage(image, for: .normal)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.tintColor = .white

        return playButton
    }()

    private let separatorView: UIView = {
        let separatorView: UIView = UIView()
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = .systemGray

        return separatorView
    }()

    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overrides

    override func prepareForReuse() {
        super.prepareForReuse()

        cinemaImageView.kf.cancelDownloadTask()
        cinemaImageView.image = nil
    }

    // MARK: - Methods

    func setup(with model: UpcomingCinemaTableViewCell.Model) {
        cinemaImageView.kf.setImage(for: model.path)
        titleLabel.text = model.title
    }
}

// MARK: - Private methods

private extension SearchCinemaTableViewCell {

    func configure() {
        backgroundColor = .clear
        [cinemaImageView, titleLabel, playButton, separatorView].forEach { contentView.addSubview($0) }
        NSLayoutConstraint.activate([
            cinemaImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15.0),
            cinemaImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15.0),
            cinemaImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.0),
            cinemaImageView.widthAnchor.constraint(equalToConstant: 100.0),
            cinemaImageView.heightAnchor.constraint(equalToConstant: 140.0),

            titleLabel.leadingAnchor.constraint(equalTo: cinemaImageView.trailingAnchor, constant: 15.0),
            titleLabel.trailingAnchor.constraint(equalTo: playButton.leadingAnchor, constant: -15.0),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            playButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15.0),
            playButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            playButton.widthAnchor.constraint(equalToConstant: 40.0),
            playButton.heightAnchor.constraint(equalToConstant: 40.0),

            separatorView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -0.5),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
}
