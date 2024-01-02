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
        configureTableView()
        configureBinding()
    }

    func configureUI() {
        navigationItem.title = String(localized: "search.title")
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

        let customHeaderView = createHeaderView()
        tableView.tableHeaderView = customHeaderView
    }

    // Create a custom header view
    func createHeaderView() -> UIView {
        let screenWidth = UIScreen.main.bounds.width

        // Create the header view
        let headerView = UIView()//(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 320)) // Total height: 20 + 300 = 320

        // Create the stack view
        let stackView = UIStackView()//frame: CGRect(x: 0, y: 0, width: screenWidth, height: 320))
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill

        // Create the first subview with a height of 20
        let view1 = UIView()
        view1.backgroundColor = .blue

        // Create the second subview with a height of 300 initially
        let view2 = UIView()
        view2.backgroundColor = .green


        // Add the subviews to the stack view
        stackView.addArrangedSubview(view1)
        stackView.addArrangedSubview(view2)

        // Add the stack view to the header view
        headerView.addSubview(stackView)

        // Constraints for the stack view to fill the header view
        headerView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view2.translatesAutoresizingMaskIntoConstraints = false
        view1.translatesAutoresizingMaskIntoConstraints = false
        let view2HeightConstraint = view2.heightAnchor.constraint(equalToConstant: 300.0)
        NSLayoutConstraint.activate([
            headerView.widthAnchor.constraint(equalToConstant: screenWidth),
            stackView.topAnchor.constraint(equalTo: headerView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            stackView.heightAnchor.constraint(lessThanOrEqualToConstant: 320.0),
            view1.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            view1.heightAnchor.constraint(equalToConstant: 20.0),
            view2.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            view2HeightConstraint,
        ])

        // Hide the longer view part after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {

            UIView.animate(withDuration: 0.3) {
                view2HeightConstraint.constant = 0
                view2.isHidden = true
                headerView.layoutIfNeeded()
                self.tableView.tableHeaderView = headerView
            }
        }

        return headerView
    }

    func configureBinding() {
        viewModel.dataChangedSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak tableView] _ in tableView?.reloadData() }
            .store(in: &cancelBag)
    }
}
