import UIKit

final class LoginCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let checkerService = CheckerService()
        let loginInspector = LoginInspector(checkerService: checkerService)
        let loginVC = LoginViewController(delegate: loginInspector)
        loginInspector.viewController = loginVC
        navigationController.setViewControllers([loginVC], animated: false)
    }
}
