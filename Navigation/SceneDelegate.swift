import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    private var loginInspector: LoginInspector?
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        // Фабрика для LoginInspector
        let factory = MyLoginFactory()
        let inspector = factory.makeLoginInspector()
        self.loginInspector = inspector
        
        // LoginViewController
        let loginVC = LoginViewController()
        loginVC.loginDelegate = inspector
        let loginNavController = UINavigationController(rootViewController: loginVC)
        loginNavController.tabBarItem = UITabBarItem(
            title: "Login",
            image: UIImage(systemName: "person.crop.circle"),
            tag: 0
        )
        
        // ProfileViewController
        let profileVC = ProfileViewController()
        let profileNavController = UINavigationController(rootViewController: profileVC)
        profileNavController.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person.fill"),
            tag: 1
        )
        
        // FeedViewController
        let feedVC = FeedViewController()
        let feedNavController = UINavigationController(rootViewController: feedVC)
        feedNavController.tabBarItem = UITabBarItem(
            title: "Feed",
            image: UIImage(systemName: "newspaper"),
            tag: 2
        )
        
        let photosVC = PhotosViewController()
        let photosNavController = UINavigationController(rootViewController: photosVC)
        photosNavController.tabBarItem = UITabBarItem(
            title: "Photos",
            image: UIImage(systemName: "photo.on.rectangle"),
            tag: 3
        )
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [
            loginNavController,
            profileNavController,
            feedNavController,
            photosNavController   // ← ДОБАВЛЕН
        ]
        
        window.rootViewController = tabBarController
        self.window = window
        window.makeKeyAndVisible()
    }
}
