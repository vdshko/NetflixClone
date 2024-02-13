//
//  MainTabBarController.swift
//  NetflixClone
//
//  Created by Vladyslav Shkodych on 05.12.2023.
//

import SwiftUI
import Combine

final class MainTabBarController: UITabBarController {

    // MARK: - Properties

    private var previousSelectedTabIndex: Int = Tabs.home.rawValue
    private var cancelBag: Set<AnyCancellable> = Set<AnyCancellable>()

    private let diContainer: DIContainer

    // MARK: - Initializers

    init(diContainer: DIContainer) {
        self.diContainer = diContainer

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
        configureBinding()
    }

    func configureTabs() {
        let tabControllers: [UINavigationController] = [
            HomeViewController(
                viewModel: HomeViewModelImpl(
                    model: HomeModelImpl(diContainer: diContainer)
                )
            ),
            UpcomingViewController(
                viewModel: UpcomingViewModelImpl(
                    model: UpcomingModelImpl(diContainer: diContainer)
                )
            ),
            SearchViewController(
                viewModel: SearchViewModelImpl(
                    model: SearchModelImpl(diContainer: diContainer)
                )
            )
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
            let result: Response<ConfigurationDetails> = await Requests.Configuration.details(networkManager: diContainer.networkManager)
            switch result {
            case .failure(let error): Logger.error(error)
            case .success(let details):
                Requests.Constants.Images.updateBaseUrl(to: details.images.secureBaseUrl)
            }
        }
    }

    func configureBinding() {
        diContainer.appState.$isTabBarHidden
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink { [weak self] _ in self?.toggleTabBar() }
            .store(in: &cancelBag)
    }

    func toggleTabBar() {
        UIView.animate(
            withDuration: 1.0,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.7,
            options: .curveEaseOut
        ) {
            let nextOriginY: CGFloat = self.tabBar.frame.height + (UIApplication.shared.rootViewController?.view.safeAreaInsets.bottom ?? 0.0)
            if self.diContainer.appState.isTabBarHidden {
                self.tabBar.frame.origin.y += nextOriginY
                self.tabBar.alpha = 0
            } else {
                self.tabBar.frame.origin.y -= nextOriginY
                self.tabBar.alpha = 1
            }
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - Tabs

extension MainTabBarController {

    enum Tabs: Int, CaseIterable {

        case home
        case upcoming
        case search

        var title: String {
            switch self {
            case .home: return String(localized: "tab.home")
            case .upcoming: return String(localized: "tab.upcoming")
            case .search: return String(localized: "tab.search")
            }
        }

        var icon: UIImage? {
            switch self {
            case .home: return UIImage(systemName: "house")
            case .upcoming: return UIImage(systemName: "play.circle")
            case .search: return UIImage(systemName: "magnifyingglass")
            }
        }
    }
}

// MARK: - Preview

private struct MainTabBarControllerRepresentable: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> UIViewController {
        let networkManagerFactory: NetworkManagerFactory = NetworkManagerFactoryImpl()
        let networkManager: NetworkManager = networkManagerFactory.createNetworkManager()
        let diContainer: DIContainer = DIContainer(
            appState: AppState(),
            networkManager: networkManager
        )

        return MainTabBarController(diContainer: diContainer)
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

@available(iOS 17, *)
#Preview {
    MainTabBarControllerRepresentable()
}
