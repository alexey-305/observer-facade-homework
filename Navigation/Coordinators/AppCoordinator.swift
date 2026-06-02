import UIKit

final class AppCoordinator {

    private let window: UIWindow
    private let factory: LoginFactory

    init(window: UIWindow, factory: LoginFactory) {
        self.window = window
        self.factory = factory
    }

    func start() {
        let inspector = factory.makeLoginInspector()

        let loginVC = LoginViewController(delegate: inspector)

        let nav = UINavigationController(rootViewController: loginVC)
        window.rootViewController = nav
        window.makeKeyAndVisible()
    }
}
