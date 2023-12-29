//
//  HomeHeaderView.swift
//  NetflixClone
//
//  Created by Vladyslav Shkodych on 07.12.2023.
//

import UIKit

final class HomeHeaderView: UIView {

    // MARK: - UI

    private lazy var backgroundImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constants.Layout.cornerRadius
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(resource: .debugHeaderBackground)

        return imageView
    }()

    private lazy var playButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle(String(localized: "home.header.play_button.title"), for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = Constants.Layout.borderWidth
        button.layer.cornerRadius = Constants.Layout.cornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    private lazy var downloadButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle(String(localized: "home.header.download_button.title"), for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = Constants.Layout.borderWidth
        button.layer.cornerRadius = Constants.Layout.cornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    // MARK: - Properties

    private var model: Model = Model()
    
    private let gradient: CAGradientLayer = CAGradientLayer()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        configure()
    }

    // MARK: - Overrides
    
    override func layoutSubviews() {
        super.layoutSubviews()

        gradient.frame = bounds
    }

    // MARK: - Methods

    func setup(with model: Model) {
        self.model = model
    }
}

// MARK: - Private methods

private extension HomeHeaderView {

    func configure() {
        configureUI()
    }

    func configureUI() {
        configureBackground()
        configureButtons()
    }

    func configureBackground() {
        addSubview(backgroundImageView)
        NSLayoutConstraint.activate([
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        gradient.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        gradient.frame = bounds
        layer.addSublayer(gradient)
    }

    func configureButtons() {
        [playButton, downloadButton].forEach { addSubview($0) }
        NSLayoutConstraint.activate([
            playButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3),
            playButton.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -10.0),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20.0),

            downloadButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3),
            downloadButton.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 10.0),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20.0)
        ])
    }
}
