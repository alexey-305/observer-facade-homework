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
        // Feed
        let feedNavController = UINavigationController()
        let feedCoordinator = FeedCoordinator(navigationController: feedNavController)
        feedCoordinator.start()
        childCoordinators.append(feedCoordinator)
        feedNavController.tabBarItem = UITabBarItem(
            title: "Feed",
            image: UIImage(systemName: "newspaper"),
            tag: 0
        )
        
        // Profile
        let profileNavController = UINavigationController()
        let profileCoordinator = ProfileCoordinator(navigationController: profileNavController)
        profileCoordinator.start()
        childCoordinators.append(profileCoordinator)
        profileNavController.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person.crop.circle"),
            tag: 1
        )
        
        // Photos
        let photosVC = PhotosViewController()
        let photosNavController = UINavigationController(rootViewController: photosVC)
        photosNavController.tabBarItem = UITabBarItem(
            title: "Photos",
            image: UIImage(systemName: "photo.on.rectangle"),
            tag: 2
        )
        
        // Music (Аудиоплеер)
        let audioVC = AudioPlayerViewController()
        let audioNavController = UINavigationController(rootViewController: audioVC)
        audioNavController.tabBarItem = UITabBarItem(
            title: "Music",
            image: UIImage(systemName: "music.note"),
            tag: 3
        )
        
        // Info (для заданий JSON/Codable)
        let infoVC = InfoViewController()
        let infoNavController = UINavigationController(rootViewController: infoVC)
        infoNavController.tabBarItem = UITabBarItem(
            title: "Info",
            image: UIImage(systemName: "info.circle"),
            tag: 4
        )
        
        tabBarController.viewControllers = [
            feedNavController,
            profileNavController,
            photosNavController,
            audioNavController,
            infoNavController
        ]
    }
}
