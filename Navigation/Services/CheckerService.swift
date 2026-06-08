import Foundation
import FirebaseAuth

protocol CheckerServiceProtocol {
    func checkCredentials(email: String, password: String, completion: @escaping (Result<FirebaseAuth.User, Error>) -> Void)
    func signUp(email: String, password: String, completion: @escaping (Result<FirebaseAuth.User, Error>) -> Void)
    func signOut() throws
    func getCurrentUser() -> FirebaseAuth.User?
}

class CheckerService: CheckerServiceProtocol {
    
    func checkCredentials(email: String, password: String, completion: @escaping (Result<FirebaseAuth.User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let user = authResult?.user else {
                let error = NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Пользователь не найден"])
                completion(.failure(error))
                return
            }
            
            completion(.success(user))
        }
    }
    
    func signUp(email: String, password: String, completion: @escaping (Result<FirebaseAuth.User, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let user = authResult?.user else {
                let error = NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Не удалось создать пользователя"])
                completion(.failure(error))
                return
            }
            
            completion(.success(user))
        }
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    func getCurrentUser() -> FirebaseAuth.User? {
        return Auth.auth().currentUser
    }
}
