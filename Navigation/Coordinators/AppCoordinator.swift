import UIKit

class AppCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
    }
    
    func start() {
        setupTabBarCoordinator()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    private func setupTabBarCoordinator() {
        let tabBarCoordinator = TabBarCoordinator(navigationController: navigationController)
        addChildCoordinator(tabBarCoordinator)
        tabBarCoordinator.start()
    }
}
