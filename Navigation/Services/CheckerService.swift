import Foundation
import FirebaseAuth

protocol CheckerServiceProtocol {
    func checkCredentials(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
    func signUp(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
}

final class CheckerService: CheckerServiceProtocol {
    
    func checkCredentials(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        print("📧📧📧 CheckerService.checkCredentials ВЫЗВАН для: \(email)")
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("❌ CheckerService ошибка входа: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                print("✅ CheckerService успешный вход: \(email)")
                completion(.success(()))
            }
        }
    }
    
    func signUp(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        print("📝📝📝 CheckerService.signUp ВЫЗВАН для: \(email)")
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("❌ CheckerService ошибка регистрации: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                print("✅ CheckerService успешная регистрация: \(email)")
                completion(.success(()))
            }
        }
    }
}
