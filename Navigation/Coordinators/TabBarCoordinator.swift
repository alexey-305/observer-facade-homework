import UIKit

class TabBarCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    private let tabBarController = UITabBarController()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        setupTabs()
        navigationController.setViewControllers([tabBarController], animated: false)
    }
    
    private func setupTabs() {
        // Login Coordinator
        let loginNavController = UINavigationController()
        let loginCoordinator = LoginCoordinator(navigationController: loginNavController)
        loginCoordinator.start()
        addChildCoordinator(loginCoordinator)
        
        loginNavController.tabBarItem = UITabBarItem(
            title: "Login",
            image: UIImage(systemName: "person.crop.circle"),
            tag: 0
        )
        
        // Feed Coordinator
        let feedNavController = UINavigationController()
        let feedCoordinator = FeedCoordinator(navigationController: feedNavController)
        feedCoordinator.start()
        addChildCoordinator(feedCoordinator)
        
        feedNavController.tabBarItem = UITabBarItem(
            title: "Feed",
            image: UIImage(systemName: "newspaper"),
            tag: 1
        )
        
        // Profile Coordinator
        let profileNavController = UINavigationController()
        let profileCoordinator = ProfileCoordinator(navigationController: profileNavController)
        profileCoordinator.start()
        addChildCoordinator(profileCoordinator)
        
        profileNavController.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person.fill"),
            tag: 2
        )
        
        // Photos Coordinator
        let photosNavController = UINavigationController()
        let photosCoordinator = PhotosCoordinator(navigationController: photosNavController)
        photosCoordinator.start()
        addChildCoordinator(photosCoordinator)
        
        photosNavController.tabBarItem = UITabBarItem(
            title: "Photos",
            image: UIImage(systemName: "photo.on.rectangle"),
            tag: 3
        )
        
        tabBarController.viewControllers = [
            loginNavController,
            feedNavController,
            profileNavController,
            photosNavController
        ]
    }
}
