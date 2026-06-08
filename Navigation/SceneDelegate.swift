import UIKit
import KeychainAccess

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)

        let keychain = Keychain(service: "com.navigation.app.password")
        let hasPassword = (try? keychain.get("userPassword")) != nil

        let passwordVC = PasswordViewController(hasPassword: hasPassword)
        window?.rootViewController = passwordVC
        window?.makeKeyAndVisible()
    }

    func showMainScreen() {
        let tabBarController = MainTabBarController()
        tabBarController.modalPresentationStyle = .fullScreen
        window?.rootViewController = tabBarController
    }
}
