import UIKit

final class LoginViewController: UIViewController {

    weak var delegate: LoginViewControllerDelegate?

    init(delegate: LoginViewControllerDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)

        button.frame = CGRect(x: 100, y: 200, width: 100, height: 50)
        view.addSubview(button)
    }

    @objc private func loginTapped() {
        delegate?.didLogin()
    }
}
