import Foundation

final class Checker {
    static let shared = Checker()
    private init() {}
    
    private let validLogin = "1234"
    private let validPassword = "0987"
    
    func check(login: String, password: String) throws -> Bool {
        // Задача 4: preconditionFailure
        precondition(!login.isEmpty, "Логин не может быть пустым в production версии")
        
        if login.isEmpty {
            throw AppError.invalidLogin
        }
        if password.isEmpty {
            throw AppError.invalidPassword
        }
        if login != validLogin {
            throw AppError.userNotFound
        }
        if password != validPassword {
            throw AppError.weakPassword("Пароль должен содержать хотя бы 4 символа")
        }
        return true
    }
}
