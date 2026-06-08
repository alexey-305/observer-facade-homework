//
//  LoginInspector.swift
//  Navigation
//

import Foundation
import FirebaseAuth

protocol LoginViewControllerDelegate: AnyObject {
    func didLogin(email: String, password: String)
    func didTapSignUp(email: String, password: String)
    func showError(_ message: String)
    func loginSuccess()
}

class LoginInspector: LoginViewControllerDelegate {
    
    weak var viewController: LoginViewController?
    private let checkerService: CheckerServiceProtocol
    
    init(checkerService: CheckerServiceProtocol) {
        self.checkerService = checkerService
    }
    
    func didLogin(email: String, password: String) {
        guard !email.isEmpty, email.contains("@") else {
            viewController?.showError("Введите корректный email")
            return
        }
        
        guard password.count >= 6 else {
            viewController?.showError("Пароль должен содержать минимум 6 символов")
            return
        }
        
        checkerService.checkCredentials(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    print("✅ Успешный вход: \(user.email ?? "")")
                    UserDefaults.standard.set(user.email, forKey: "currentUserEmail")
                    self?.viewController?.loginSuccess()
                    
                case .failure(let error as NSError) where error.code == 17011:
                    print("👤 Пользователь не найден, регистрируем...")
                    self?.didTapSignUp(email: email, password: password)
                    
                case .failure(let error):
                    print("❌ Ошибка: \(error.localizedDescription)")
                    self?.viewController?.showError(error.localizedDescription)
                }
            }
        }
    }
    
    func didTapSignUp(email: String, password: String) {
        guard !email.isEmpty, email.contains("@") else {
            viewController?.showError("Введите корректный email")
            return
        }
        
        guard password.count >= 6 else {
            viewController?.showError("Пароль должен содержать минимум 6 символов")
            return
        }
        
        checkerService.signUp(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    print("✅ Регистрация успешна: \(user.email ?? "")")
                    UserDefaults.standard.set(user.email, forKey: "currentUserEmail")
                    self?.viewController?.loginSuccess()
                    
                case .failure(let error):
                    print("❌ Ошибка регистрации: \(error.localizedDescription)")
                    self?.viewController?.showError(error.localizedDescription)
                }
            }
        }
    }
    
    func showError(_ message: String) {
        viewController?.showError(message)
    }
    
    func loginSuccess() {
        viewController?.loginSuccess()
    }
}
