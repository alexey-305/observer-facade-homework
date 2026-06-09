import UIKit
import FirebaseAuth

final class TabBarCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    private let tabBarController = UITabBarController()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        setupTabBar()
        navigationController.setViewControllers([tabBarController], animated: false)
    }
    
    private func setupTabBar() {
        // Feed
        let feedVC = FeedViewController()
        feedVC.title = "Лента"
        let feedNav = UINavigationController(rootViewController: feedVC)
        feedNav.tabBarItem = UITabBarItem(title: "Лента", image: UIImage(systemName: "house"), tag: 0)
        
        // Profile
        let profileNav = UINavigationController()
        let profileCoordinator = ProfileCoordinator(navigationController: profileNav)
        profileCoordinator.start()
        profileNav.tabBarItem = UITabBarItem(title: "Профиль", image: UIImage(systemName: "person"), tag: 1)
        
        tabBarController.viewControllers = [feedNav, profileNav]
    }
}
