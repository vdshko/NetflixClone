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
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false

        return tableView
    }()

    // MARK: - Properties

    private var disposeBag: Set<AnyCancellable> = Set<AnyCancellable>()

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
        guard let cell: UITableViewCell = tableView.cell(for: CellIdentifiers.default)
        else { return UITableViewCell() }
        let model: Cinema = viewModel.pagedModel.results[indexPath.row]
        cell.textLabel?.text = model.title ?? model.originalTitle

        return cell
    }
}

// MARK: - UITableViewDelegate

extension UpcomingViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - TabBarUpdatable

extension UpcomingViewController: TabBarSelectable {

    func handleTabItemTap(isPreviouslySelected: Bool) {
        guard isPreviouslySelected else { return }
        let percent2HeightOfScreen: CGFloat
        if let height: CGFloat = UIApplication.shared.rootViewController?.view.bounds.height {
            percent2HeightOfScreen = height * 0.02
        } else {
            percent2HeightOfScreen = 30.0
        }
        let navigationBarBackgroundHeight: CGFloat = navigationController?.navigationBar.subviews
            .first { NSStringFromClass($0.classForCoder) == "_UIBarBackground" }?
            .frame.height ?? 0.0
        guard tableView.contentOffset.y + navigationBarBackgroundHeight > percent2HeightOfScreen else { return }
        tableView.setContentOffset(CGPoint(x: 0.0, y: -navigationBarBackgroundHeight), animated: true)
    }
}

// MARK: - Private methods

private extension UpcomingViewController {

    func configure() {
        configureUI()
        configureTableView()
        configureSubscriptions()
    }

    func configureUI() {
        title = String(localized: "upcoming.title")
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

    func configureSubscriptions() {
        viewModel.dataChangedSubject
            .receive(on: RunLoop.main)
            .sink { [weak tableView] _ in tableView?.reloadData() }
            .store(in: &disposeBag)
    }
}
