import UIKit

class LoginCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let factory = MyLoginFactory()
        let inspector = factory.makeLoginInspector()
        
        let loginVC = LoginViewController()
        loginVC.loginDelegate = inspector
        
        navigationController.setViewControllers([loginVC], animated: false)
    }
}
