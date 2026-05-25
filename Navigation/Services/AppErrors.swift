import Foundation

enum AppError: Error {
    case invalidLogin
    case invalidPassword
    case weakPassword(String)
    case networkError(String)
    case userNotFound
    case loginAlreadyTaken
    case unknown(String)
    
    var localizedDescription: String {
        switch self {
        case .invalidLogin:
            return "Логин не может быть пустым"
        case .invalidPassword:
            return "Пароль не может быть пустым"
        case .weakPassword(let message):
            return "Слабый пароль: \(message)"
        case .networkError(let message):
            return "Ошибка сети: \(message)"
        case .userNotFound:
            return "Пользователь не найден"
        case .loginAlreadyTaken:
            return "Логин уже занят"
        case .unknown(let message):
            return "Неизвестная ошибка: \(message)"
        }
    }
}
