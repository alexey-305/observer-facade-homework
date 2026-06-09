import Foundation
import UIKit

class ApplicationAssembly {
    
    func makeLoginViewController() -> LoginViewController {
        let checkerService = CheckerService()
        let loginInspector = LoginInspector(checkerService: checkerService)
        let loginVC = LoginViewController(delegate: loginInspector)
        loginInspector.viewController = loginVC
        return loginVC
    }
}
