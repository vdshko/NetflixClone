//
//  MainTabBarController.swift
//  NetflixClone
//
//  Created by Vladyslav Shkodych on 05.12.2023.
//

import UIKit

final class MainTabBarController: UITabBarController {

    private let networkManager: NetworkManager

    init(networkManager: NetworkManager) {
        self.networkManager = networkManager

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("\(String(describing: Self.self)) init(coder:) - has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }
}

// MARK: - Private methods

private extension MainTabBarController {

    func configure() {
        configureTabs()
        configureUI()
    }

    func configureTabs() {
        let tabControllers: [UINavigationController] = [
            HomeViewController(
                viewModel: HomeViewModelImpl(
                    model: HomeModelImpl(networkManager: networkManager)
                )
            ),
            UpcomingViewController(),
            SearchViewController(),
            DownloadsViewController()
        ].map(UINavigationController.init)
        zip(tabControllers, Tabs.allCases).forEach {
            $0.0.title = $0.1.title
            $0.0.tabBarItem.image = $0.1.icon
        }
        setViewControllers(tabControllers, animated: true)
    }

    func configureUI() {
        tabBar.tintColor = UIColor(resource: .tabBarTint)
        tabBar.backgroundColor = UIColor(resource: .tabBarBackground)
    }
}

// MARK: - Tabs

extension MainTabBarController {

    enum Tabs: CaseIterable {

        case home
        case upcoming
        case search
        case downloads

        var title: String {
            switch self {
            case .home: return String(localized: "tab.home")
            case .upcoming: return String(localized: "tab.upcoming")
            case .search: return String(localized: "tab.search")
            case .downloads: return String(localized: "tab.downloads")
            }
        }

        var icon: UIImage? {
            switch self {
            case .home: return UIImage(systemName: "house")
            case .upcoming: return UIImage(systemName: "play.circle")
            case .search: return UIImage(systemName: "magnifyingglass")
            case .downloads: return UIImage(systemName: "arrow.down.to.line")
            }
        }
    }
}
