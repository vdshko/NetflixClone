//
//  HomeViewController.swift
//  NetflixClone
//
//  Created by Vladyslav Shkodych on 05.12.2023.
//

import SwiftUI

final class HomeViewController: UIViewController {

    // MARK: - UI

    private lazy var tableView: UITableView = {
        let tableView: UITableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false

        return tableView
    }()

    // MARK: - Properties

    private let viewModel: HomeViewModel = HomeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }
}

// MARK: - UITableViewDataSource

extension HomeViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.data.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: CollectionViewTableViewCell = tableView.cell(for: CellIdentifiers.collection)
        else { return UITableViewCell() }
        let model: CollectionViewTableViewCell.Model = .init(data: viewModel.data)
        cell.setup(with: model)

        return cell
    }
}

// MARK: - UITableViewDelegate

extension HomeViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200.0
    }
}

// MARK: - Private methods

private extension HomeViewController {

    func configure() {
        configureUI()
    }

    func configureUI() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        let size: CGSize = CGSize(width: view.bounds.width, height: 450.0)
        tableView.tableHeaderView = HomeHeaderView(frame: CGRect(origin: .zero, size: size))
    }
}
