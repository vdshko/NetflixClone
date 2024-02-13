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

    private lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let size: CGSize = UIApplication.shared.rootViewController?.view.bounds.size ?? CGSize(width: 100.0, height: 200.0)
        layout.itemSize = CGSize(width: size.width / 3.0 - 10.0, height: 200.0)
        layout.minimumInteritemSpacing = 0.0
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        return collectionView
    }()

    // MARK: - Properties

    private var searchQuery: String?
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

    // MARK: - Methods

    func updateSearchQuery(with searchQuery: String?) {
        self.searchQuery = searchQuery
        viewModel.updateSearchQuery(with: searchQuery)
    }
}

// MARK: - UICollectionViewDataSource

extension SearchResultsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.pagedModel.results.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: CinemaPosterCollectionViewCell = collectionView.cell(for: CellIdentifiers.cinemaPoster, in: indexPath)
        else { return UICollectionViewCell() }
        let data: Cinema = viewModel.pagedModel.results[indexPath.row]
        cell.setup(image: data.posterPath)

        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension SearchResultsViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
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
        configureCollectionView()
    }

    func configureCollectionView() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func configureBinding() {
        viewModel.dataChangedSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak collectionView] _ in collectionView?.reloadData() }
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
