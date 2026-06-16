import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var coordinator: AppCoordinator?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)

        let navigationController = UINavigationController()

        let coordinator = AppCoordinator(navigationController: navigationController)
        coordinator.start()

        self.coordinator = coordinator

        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
    }
}
