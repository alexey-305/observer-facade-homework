import UIKit
import FirebaseAuth
import KeychainAccess

final class AppCoordinator {
    
    private let navigationController: UINavigationController
    private var loginInspector: LoginInspector?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        print("🟢 AppCoordinator инициализирован")
    }
    
    func start() {
        print("🟢 AppCoordinator.start()")
        
        print("DEBUG: currentUser = \(Auth.auth().currentUser?.email ?? "nil")")
        
        if Auth.auth().currentUser != nil {
            checkLocalPassword()
        } else {
            showLogin()
        }
    }
    
    func showLogin() {
        print("🟢 Показываем LoginViewController")
        
        let checkerService = CheckerService()
        let inspector = LoginInspector(checkerService: checkerService)
        self.loginInspector = inspector
        let loginVC = LoginViewController(delegate: inspector)
        inspector.viewController = loginVC
        
        navigationController.setViewControllers([loginVC], animated: false)
    }
    
    func checkLocalPassword() {
        print("🟢 Проверяем локальный пароль")
        
        let keychain = Keychain(service: "com.navigation.app.password")
        let hasPassword = (try? keychain.get("userPassword")) != nil
        print("DEBUG: hasPassword = \(hasPassword)")
        
        let passwordVC = PasswordViewController(hasPassword: hasPassword)
        passwordVC.modalPresentationStyle = .fullScreen
        navigationController.present(passwordVC, animated: true)
    }
    
    func showMainFlow() {
        print("🟢 Переход на главный экран (TabBar)")
        
        navigationController.dismiss(animated: true)
        let tabBarController = MainTabBarController()
        navigationController.setViewControllers([tabBarController], animated: true)
    }
    
    func showPasswordCreationScreen() {
        print("🟢 Показываем экран создания пароля после логина")
        
        let passwordVC = PasswordViewController(hasPassword: false)
        passwordVC.modalPresentationStyle = .fullScreen
        navigationController.present(passwordVC, animated: true)
    }
}
