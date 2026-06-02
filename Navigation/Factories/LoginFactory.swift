import UIKit

protocol LoginFactory {
    func makeLoginInspector() -> LoginViewControllerDelegate
}

struct MyLoginFactory: LoginFactory {

    func makeLoginInspector() -> LoginViewControllerDelegate {
        LoginInspector()
    }
}
