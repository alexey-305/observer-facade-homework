import UIKit
import FirebaseAuth

final class AppCoordinator {
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        print("🟢 AppCoordinator инициализирован")
    }
    
    func start() {
        print("🟢 AppCoordinator.start()")
        
        if Auth.auth().currentUser != nil {
            showMainFlow()
        } else {
            showLogin()
        }
    }
    
    func showLogin() {
        print("🟢 Показываем LoginViewController")
        
        let checkerService = CheckerService()
        let loginInspector = LoginInspector(checkerService: checkerService)
        let loginVC = LoginViewController(delegate: loginInspector)
        loginInspector.viewController = loginVC
        
        navigationController.setViewControllers([loginVC], animated: false)
    }
    
    func showMainFlow() {
        print("🟢 Переход на главный экран (TabBar)")
        
        let tabBarController = UITabBarController()
        
        let feedVC = FeedViewController()
        feedVC.title = "Лента"
        let feedNav = UINavigationController(rootViewController: feedVC)
        feedNav.tabBarItem = UITabBarItem(title: "Лента", image: UIImage(systemName: "house"), tag: 0)
        
        let email = Auth.auth().currentUser?.email
        let profileVC = ProfileViewController(email: email)
        profileVC.title = "Профиль"
        let profileNav = UINavigationController(rootViewController: profileVC)
        profileNav.tabBarItem = UITabBarItem(title: "Профиль", image: UIImage(systemName: "person"), tag: 1)
        
        tabBarController.viewControllers = [feedNav, profileNav]
        navigationController.setViewControllers([tabBarController], animated: true)
    }
}
