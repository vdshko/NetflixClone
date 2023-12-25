//
//  HomeViewController.swift
//  NetflixClone
//
//  Created by Vladyslav Shkodych on 05.12.2023.
//

import SwiftUI

final class HomeViewController: BaseViewController {

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

    private let viewModel: HomeViewModel

    // MARK: - Initializer

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel

        super.init()
        
        self.viewModel.dataChangedCallback = { [weak tableView] dataType in
            guard let index: Int = HomeDataType.allCases.firstIndex(of: dataType) else { return }
            tableView?.reloadSections([index], with: .automatic)
        }
    }

    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        viewModel.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension HomeViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.pagedModels.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section < HomeDataType.allCases.count ? HomeDataType.allCases[section].title : nil
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: CollectionViewTableViewCell = tableView.cell(for: CellIdentifiers.collection)
        else { return UITableViewCell() }
        let data: [Int]? = viewModel.pagedModels[HomeDataType.allCases[indexPath.section]]?
            .results
            .map(\.id)
        let model: CollectionViewTableViewCell.Model = .init(data: data ?? [])
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

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header: UITableViewHeaderFooterView = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = .white
        header.textLabel?.font = .systemFont(ofSize: 18.0, weight: .semibold)
        header.textLabel?.text = header.textLabel?.text?.capitalizedFirst
        let inset: CGFloat = 20.0
        header.textLabel?.frame = CGRect(
            x: header.bounds.origin.x + inset,
            y: header.bounds.origin.y,
            width: header.bounds.width - inset,
            height: header.bounds.height
        )
    }
}

// MARK: - ScrollViewDelegate

extension HomeViewController {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset: CGFloat = view.safeAreaInsets.top
        let offset: CGFloat = scrollView.contentOffset.y + defaultOffset
        navigationController?.navigationBar.transform = .init(translationX: 0, y: -max(0, offset))
        let valuePercent: Int = Int((defaultOffset - offset * 2) * 100 / defaultOffset)
        let value: CGFloat = CGFloat(valuePercent) / 100.0
        navigationController?.navigationBar.alpha = max(value, 0.1)
        navigationItem.leftBarButtonItem?.customView?.alpha = value
        navigationItem.rightBarButtonItem?.customView?.alpha = value
    }
}

// MARK: - TabBarUpdatable

extension HomeViewController: TabBarSelectable {
    
    func handleTabItemTap(isPreviouslySelected: Bool) {
        guard isPreviouslySelected else { return }
        let percent10HeightOfScreen: CGFloat
        if let height: CGFloat = UIApplication.shared.rootViewController?.view.bounds.height {
            percent10HeightOfScreen = height * 0.10
        } else {
            percent10HeightOfScreen = 80.0
        }
        let navigationBarBackgroundHeight: CGFloat = navigationController?.navigationBar.subviews
            .first { NSStringFromClass($0.classForCoder) == "_UIBarBackground" }?
            .frame.height ?? 0.0
        guard tableView.contentOffset.y + navigationBarBackgroundHeight > percent10HeightOfScreen else { return }
        tableView.setContentOffset(CGPoint(x: 0.0, y: -navigationBarBackgroundHeight), animated: true)
    }
}

// MARK: - Private methods

private extension HomeViewController {

    func configure() {
        configureNavigationBar()
        configureTableView()
    }

    func configureNavigationBar() {
        let leftButtonAction: UIAction = UIAction { [weak self] _ in self?.viewModel.nextData(for: .trending(.movie)) }
        let leftButton: UIButton = UIButton(frame: .zero, primaryAction: leftButtonAction)
        let leftButtonImage: UIImage = UIImage(resource: .netflixLogo)
            .withAlignmentRectInsets(.init(top: -8, left: -8, bottom: -8, right: -8))
        leftButton.setImage(leftButtonImage, for: .normal)
        leftButton.imageView?.contentMode = .scaleAspectFit
        leftButton.imageView?.translatesAutoresizingMaskIntoConstraints = false
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leftButton.widthAnchor.constraint(equalToConstant: 45.0),
            leftButton.heightAnchor.constraint(equalToConstant: 44.0)
        ])
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        let stackView: UIStackView = UIStackView()
        stackView.spacing = 8.0
        let rightButtonAction1: UIAction = UIAction { _ in }
        let rightButtonAction2: UIAction = UIAction { _ in }
        zip(["play.rectangle", "person"], [rightButtonAction1, rightButtonAction2]).forEach {
            let button: UIButton = UIButton(frame: .zero, primaryAction: $0.1)
            button.setImage(UIImage(systemName: $0.0), for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalToConstant: 45.0),
                button.heightAnchor.constraint(equalToConstant: 44.0)
            ])
            stackView.addArrangedSubview(button)
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: stackView)
        navigationController?.navigationBar.tintColor = UIColor(resource: .navigationBarTint)
        navigationController?.navigationBar.backgroundColor = UIColor(resource: .navigationBarBackground)
    }

    func configureTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        let size: CGSize = CGSize(width: view.bounds.width, height: 450.0)
        tableView.tableHeaderView = HomeHeaderView(frame: CGRect(origin: .zero, size: size))
    }
}
