import UIKit

final class AppCoordinator {
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        print("🟢 AppCoordinator инициализирован")
    }
    
    func start() {
        print("🟢 AppCoordinator.start()")
        showLogin()
    }
    
    private func showLogin() {
        print("🟢 Показываем LoginViewController")
        let loginVC = LoginViewController()
        
        loginVC.onLoginSuccess = { [weak self] in
            print("✅ onLoginSuccess вызван, переходим на главный экран")
            self?.showMainFlow()
        }
        
        navigationController.setViewControllers([loginVC], animated: false)
    }
    
    private func showMainFlow() {
        print("🟢 Переход на главный экран")
        let feedVC = FeedViewController()
        feedVC.title = "Feed"
        feedVC.view.backgroundColor = .white
        navigationController.setViewControllers([feedVC], animated: true)
    }
}
