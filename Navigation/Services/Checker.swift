import Foundation

final class Checker {
    static let shared = Checker()
    private init() {}
    
    private let validLogin = "1234"
    private let validPassword = "0987"
    
    func check(login: String, password: String) -> Bool {
        return login == validLogin && password == validPassword
    }
}
