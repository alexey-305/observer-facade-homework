import UIKit
import FirebaseAuth
import KeychainAccess

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        let navigationController = UINavigationController()
        appCoordinator = AppCoordinator(navigationController: navigationController)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        appCoordinator?.start()
    }
    
    func showLocalPasswordScreen() {
        appCoordinator?.checkLocalPassword()
    }
    
    func showPasswordCreationScreen() {
        appCoordinator?.showPasswordCreationScreen()
    }
}
