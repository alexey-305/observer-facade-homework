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
        let loginVC = LoginViewController()
        print("🟢 AppCoordinator создал экземпляр LoginViewController")
        
        let factory = MyLoginFactory()
        let inspector = factory.makeLoginInspector()
        loginVC.setDelegate(inspector)
        
        loginVC.onLoginSuccess = { [weak self] in
            print("🟢 Переход к TabBarCoordinator")
            let tabBarCoordinator = TabBarCoordinator(navigationController: self!.navigationController)
            self?.childCoordinators.append(tabBarCoordinator)
            tabBarCoordinator.start()
        }
        
        navigationController.setViewControllers([loginVC], animated: false)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
