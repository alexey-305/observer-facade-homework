import UIKit

final class LoginFactory {
    
    func makeViewController() -> LoginViewController {
        let checkerService = CheckerService()
        let loginInspector = LoginInspector(checkerService: checkerService)
        let loginVC = LoginViewController(delegate: loginInspector)
        loginInspector.viewController = loginVC
        return loginVC
    }
}
