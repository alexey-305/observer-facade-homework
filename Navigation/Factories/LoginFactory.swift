import UIKit

final class LoginFactory {
    
    func makeViewController() -> LoginViewController {
        let loginVC = LoginViewController()
        return loginVC
    }
}
