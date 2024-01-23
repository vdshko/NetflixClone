//
//  SearchViewController.swift
//  NetflixClone
//
//  Created by Vladyslav Shkodych on 05.12.2023.
//

import SwiftUI
import Combine

final class SearchViewController: BaseViewController {

    // MARK: - UI

    private lazy var tableView: UITableView = {
        let tableView: UITableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false

        return tableView
    }()

    private lazy var searchController: UISearchController = {
        let searchController: UISearchController = UISearchController(
            searchResultsController: SearchResultsViewController(
                viewModel: viewModel.createSearchResultsViewModel()
            )
        )
        searchController.searchBar.placeholder = String(localized: "search.search_controller.placeholder")
        searchController.searchBar.searchBarStyle = .minimal

        return searchController
    }()

    // MARK: - Properties

    private var cancelBag: Set<AnyCancellable> = Set<AnyCancellable>()

    private let viewModel: SearchViewModel

    // MARK: - Initializer

    init(viewModel: SearchViewModel) {
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

extension SearchViewController: UITableViewDataSource {

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

extension SearchViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - TabBarUpdatable

extension SearchViewController: TabBarSelectable {

    func handleTabItemTap(isPreviouslySelected: Bool) {
        guard isPreviouslySelected else { return }
        guard tableView.numberOfSections > 0,
              tableView.numberOfRows(inSection: 0) > 0
        else { return }
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .bottom, animated: true)
    }
}

// MARK: - Private methods
    
private extension SearchViewController {

    func configure() {
        configureUI()
        configureBinding()
    }

    func configureUI() {
        navigationItem.title = String(localized: "search.title")
        navigationItem.searchController = searchController
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        configureTableView()
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

private struct SearchViewControllerRepresentable: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> UIViewController {
        let networkManagerFactory: NetworkManagerFactory = NetworkManagerFactoryImpl()
        let networkManager: NetworkManager = networkManagerFactory.createNetworkManager()
        let diContainer: DIContainer = DIContainer(
            appState: AppState(),
            networkManager: networkManager
        )

        return SearchViewController(
            viewModel: SearchViewModelImpl(
                model: SearchModelImpl(diContainer: diContainer)
            )
        )
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

@available(iOS 17, *)
#Preview {
    SearchViewControllerRepresentable()
}
