//
//  SearchResultsViewController.swift
//  NetflixClone
//
//  Created by Vladyslav Shkodych on 20.01.2024.
//

import SwiftUI
import Combine

final class SearchResultsViewController: BaseViewController {

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

    private let viewModel: SearchResultsViewModel

    // MARK: - Initializer

    init(viewModel: SearchResultsViewModel) {
        self.viewModel = viewModel

        super.init()

        hidesBottomBarWhenPushed = true
    }

    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        viewModel.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.hideTabbar()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        viewModel.showTabbar()
    }
}

// MARK: - UITableViewDataSource

extension SearchResultsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.pagedModel.results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: SearchCinemaTableViewCell = tableView.cell(for: CellIdentifiers.searchCinema)
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

extension SearchResultsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Private methods

private extension SearchResultsViewController {

    func configure() {
        configureUI()
        configureBinding()
    }

    func configureUI() {
        navigationItem.title = String(localized: "search.title")
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.backgroundColor = .systemBackground
//        configureTableView()
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
            .receive(on: DispatchQueue.main)
            .sink { [weak tableView] _ in tableView?.reloadData() }
            .store(in: &cancelBag)
    }
}

// MARK: - Preview

private struct SearchResultsViewControllerRepresentable: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> UIViewController {
        let networkManagerFactory: NetworkManagerFactory = NetworkManagerFactoryImpl()
        let networkManager: NetworkManager = networkManagerFactory.createNetworkManager()
        let diContainer: DIContainer = DIContainer(
            appState: AppState(),
            networkManager: networkManager
        )

        return SearchResultsViewController(
            viewModel: SearchResultsViewModelImpl(
                model: SearchResultsModelImpl(diContainer: diContainer)
            )
        )
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

@available(iOS 17, *)
#Preview {
    SearchResultsViewControllerRepresentable()
}
