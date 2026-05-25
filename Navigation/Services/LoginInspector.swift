import Foundation

class LoginInspector: LoginViewControllerDelegate {
    func check(login: String, password: String) throws -> Bool {
        return try Checker.shared.check(login: login, password: password)
    }
}
