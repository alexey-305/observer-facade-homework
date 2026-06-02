import UIKit

protocol LoginViewControllerDelegate: AnyObject {
    func didLogin()
}

final class LoginViewController: UIViewController {

    weak var delegate: LoginViewControllerDelegate?

    @IBAction func loginButtonTapped(_ sender: UIButton) {
        delegate?.didLogin()
    }
}
