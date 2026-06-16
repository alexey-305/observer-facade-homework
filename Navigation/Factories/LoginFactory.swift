import UIKit

protocol LoginFactory {
    func makeLoginViewController() -> UIViewController
    func makeLoginInspector() -> LoginViewControllerDelegate
}

struct MyLoginFactory: LoginFactory {

    func makeLoginViewController() -> UIViewController {
        let vc = LoginViewController()
        let inspector = makeLoginInspector()
        vc.delegate = inspector
        return vc
    }

    func makeLoginInspector() -> LoginViewControllerDelegate {
        LoginInspector()
    }
}
