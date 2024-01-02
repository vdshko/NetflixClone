//
//  MainTabBarController.swift
//  NetflixClone
//
//  Created by Vladyslav Shkodych on 05.12.2023.
//

import UIKit

final class MainTabBarController: UITabBarController {

    // MARK: - Properties

    private var previousSelectedTabIndex: Int = Tabs.search.rawValue

    private let networkManager: NetworkManager

    // MARK: - Initializers

    init(networkManager: NetworkManager) {
        self.networkManager = networkManager

        super.init(nibName: nil, bundle: nil)

        requestConfigurationDetails()
    }
    
    required init?(coder: NSCoder) {
        fatalError("\(String(describing: Self.self)) init(coder:) - has not been implemented")
    }
    
    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let index: Int = tabBar.items?.firstIndex(of: item) else { return }
        let isEqualTabIndex: Bool = index == previousSelectedTabIndex
        previousSelectedTabIndex = index
        ((viewControllers?[index] as? UINavigationController)?.topViewController as? TabBarSelectable)?
            .handleTabItemTap(isPreviouslySelected: isEqualTabIndex)
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
            UpcomingViewController(
                viewModel: UpcomingViewModelImpl(
                    model: UpcomingModelImpl(networkManager: networkManager)
                )
            ),
            SearchViewController(
                viewModel: SearchViewModelImpl(
                    model: SearchModelImpl(networkManager: networkManager)
                )
            ),
            DownloadsViewController()
        ].map(UINavigationController.init)
        zip(tabControllers, Tabs.allCases).forEach {
            $0.0.title = $0.1.title
            $0.0.tabBarItem.image = $0.1.icon
        }
        setViewControllers(tabControllers, animated: true)
        selectedIndex = previousSelectedTabIndex
    }

    func configureUI() {
        tabBar.tintColor = UIColor(resource: .tabBarTint)
        tabBar.backgroundColor = UIColor(resource: .tabBarBackground)
    }

    func requestConfigurationDetails() {
        Task(priority: .high) {
            let result: Response<ConfigurationDetails> = await Requests.Configuration.details(networkManager: networkManager)
            switch result {
            case .failure(let error): Logger.error(error)
            case .success(let details):
                Requests.Constants.Images.updateBaseUrl(to: details.images.secureBaseUrl)
            }
        }
    }
}

// MARK: - Tabs

extension MainTabBarController {

    enum Tabs: Int, CaseIterable {

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
