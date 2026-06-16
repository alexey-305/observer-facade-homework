import Foundation
import FirebaseAuth

protocol LoginViewControllerDelegate: AnyObject {
    func checkCredentials(email: String, password: String)
}

final class LoginInspector: LoginViewControllerDelegate {
    
    private let checkerService: CheckerServiceProtocol
    private weak var viewController: LoginViewController?
    
    init(checkerService: CheckerServiceProtocol = CheckerService(), viewController: LoginViewController) {
        self.checkerService = checkerService
        self.viewController = viewController
        print("🟢 LoginInspector инициализирован")
    }
    
    func checkCredentials(email: String, password: String) {
        print("🔍 LoginInspector.checkCredentials вызван для: \(email)")
        
        checkerService.checkCredentials(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    print("✅ Успех в LoginInspector")
                    self?.viewController?.loginSuccess()
                case .failure(let error as NSError):
                    print("❌ Ошибка: \(error.code) - \(error.localizedDescription)")
                    if error.code == AuthErrorCode.userNotFound.rawValue {
                        print("👤 Пользователь не найден, регистрируем...")
                        self?.signUp(email: email, password: password)
                    } else {
                        self?.viewController?.showError(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    private func signUp(email: String, password: String) {
        print("📝 LoginInspector.signUp вызван для: \(email)")
        
        checkerService.signUp(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    print("✅ Регистрация успешна")
                    self?.viewController?.loginSuccess()
                case .failure(let error):
                    print("❌ Ошибка регистрации: \(error.localizedDescription)")
                    self?.viewController?.showError(error.localizedDescription)
                }
            }
        }
    }
}
