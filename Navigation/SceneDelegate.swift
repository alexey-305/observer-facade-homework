import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        let navigationController = UINavigationController()
        appCoordinator = AppCoordinator(navigationController: navigationController)
        appCoordinator?.start()
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func showMainScreen() {
        print("✅ SceneDelegate.showMainScreen() вызван")
        appCoordinator?.showMainFlow()
    }
    
    func showLoginScreen() {
        print("✅ SceneDelegate.showLoginScreen() вызван")
        appCoordinator?.showLogin()
    }
}
