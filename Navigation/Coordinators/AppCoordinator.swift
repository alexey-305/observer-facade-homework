import UIKit

final class AppCoordinator {

    private let navigationController: UINavigationController
    private let factory = MyLoginFactory()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let loginVC = factory.makeLoginViewController()
        navigationController.viewControllers = [loginVC]
    }
}
