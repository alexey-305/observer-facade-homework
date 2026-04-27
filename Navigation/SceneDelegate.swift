import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    // Сильная ссылка на делегат
    private var loginInspector: LoginInspector?
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        // ✅ ИСПОЛЬЗУЕМ ФАБРИКУ для создания LoginInspector
        let factory = MyLoginFactory()
        let inspector = factory.makeLoginInspector()
        
        // Сохраняем сильную ссылку
        self.loginInspector = inspector
        
        let loginVC = LoginViewController()
        loginVC.loginDelegate = inspector
        
        let navController = UINavigationController(rootViewController: loginVC)
        
        window.rootViewController = navController
        self.window = window
        window.makeKeyAndVisible()
        
        print("✅ loginDelegate установлен через фабрику: \(loginVC.loginDelegate != nil)")
    }
}
