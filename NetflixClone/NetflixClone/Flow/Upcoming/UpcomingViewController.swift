//
//  UpcomingViewController.swift
//  NetflixClone
//
//  Created by Vladyslav Shkodych on 05.12.2023.
//

import SwiftUI
import Combine

final class UpcomingViewController: BaseViewController {

    // MARK: - UI

    private lazy var tableView: UITableView = {
        let tableView: UITableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false

        return tableView
    }()

    // MARK: - Properties

    private var cancelBag: Set<AnyCancellable> = Set<AnyCancellable>()

    private let viewModel: UpcomingViewModel

    // MARK: - Initializer

    init(viewModel: UpcomingViewModel) {
        self.viewModel = viewModel

        super.init()
    }

    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        viewModel.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension UpcomingViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.pagedModel.results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: UpcomingCinemaTableViewCell = tableView.cell(for: CellIdentifiers.upcomingCinema)
        else { return UITableViewCell() }
        let model: Cinema = viewModel.pagedModel.results[indexPath.row]
        cell.setup(
            with: .init(
                title: model.title ?? model.originalTitle,
                path: model.posterPath
            )
        )

        return cell
    }
}

// MARK: - UITableViewDelegate

extension UpcomingViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - TabBarUpdatable

extension UpcomingViewController: TabBarSelectable {

    func handleTabItemTap(isPreviouslySelected: Bool) {
        guard isPreviouslySelected else { return }
        guard tableView.numberOfSections > 0,
              tableView.numberOfRows(inSection: 0) > 0
        else { return }
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .bottom, animated: true)
    }
}

// MARK: - Private methods

private extension UpcomingViewController {

    func configure() {
        configureUI()
        configureTableView()
        configureBinding()
    }

    func configureUI() {
        navigationItem.title = String(localized: "tab.upcoming")
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
    }

    func configureTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    func configureBinding() {
        viewModel.dataChangedSubject
            .receive(on: RunLoop.main)
            .sink { [weak tableView] _ in tableView?.reloadData() }
            .store(in: &cancelBag)
    }
}
