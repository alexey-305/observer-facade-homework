import UIKit
import KeychainAccess

class PasswordViewController: UIViewController {

    private let keychain = Keychain(service: "com.navigation.app.password")
    private let hasPassword: Bool

    private var isCreatingPassword = false
    private var firstPassword = ""

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Пароль"
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        textField.font = .systemFont(ofSize: 16)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    init(hasPassword: Bool) {
        self.hasPassword = hasPassword
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateUI()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground

        view.addSubview(titleLabel)
        view.addSubview(passwordTextField)
        view.addSubview(actionButton)
        view.addSubview(errorLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            passwordTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),

            actionButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            actionButton.heightAnchor.constraint(equalToConstant: 50),

            errorLabel.topAnchor.constraint(equalTo: actionButton.bottomAnchor, constant: 20),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])

        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
    }

    private func updateUI() {
        if hasPassword {
            titleLabel.text = "Введите пароль"
            actionButton.setTitle("Войти", for: .normal)
        } else {
            titleLabel.text = "Создайте пароль"
            actionButton.setTitle("Создать пароль", for: .normal)
            isCreatingPassword = true
        }
    }

    @objc private func actionButtonTapped() {
        errorLabel.isHidden = true
        errorLabel.text = ""

        guard let password = passwordTextField.text, !password.isEmpty else {
            showError("Введите пароль")
            return
        }

        if hasPassword {
            checkExistingPassword(password)
        } else {
            handlePasswordCreation(password)
        }
    }

    private func handlePasswordCreation(_ password: String) {
        if !isCreatingPassword {
            guard password == firstPassword else {
                showError("Пароли не совпадают. Попробуйте снова.")
                resetToInitialState()
                return
            }

            guard password.count >= 4 else {
                showError("Пароль должен содержать минимум 4 символа")
                resetToInitialState()
                return
            }

            savePassword(password)
        } else {
            guard password.count >= 4 else {
                showError("Пароль должен содержать минимум 4 символа")
                return
            }

            firstPassword = password
            isCreatingPassword = false
            titleLabel.text = "Повторите пароль"
            actionButton.setTitle("Повторите пароль", for: .normal)
            passwordTextField.text = ""
        }
    }

    private func checkExistingPassword(_ password: String) {
        guard let savedPassword = try? keychain.get("userPassword") else {
            showError("Пароль не найден")
            return
        }

        if savedPassword == password {
            print("Пароль верный")
            showMainApp()
        } else {
            showError("Неверный пароль")
        }
    }

    private func savePassword(_ password: String) {
        do {
            try keychain.set(password, key: "userPassword")
            print("Пароль сохранён в Keychain")
            showMainApp()
        } catch {
            showError("Ошибка сохранения пароля: \(error.localizedDescription)")
        }
    }

    private func resetToInitialState() {
        isCreatingPassword = true
        firstPassword = ""
        titleLabel.text = "Создайте пароль"
        actionButton.setTitle("Создать пароль", for: .normal)
        passwordTextField.text = ""
    }

    private func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
        passwordTextField.text = ""
    }

    private func showMainApp() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        sceneDelegate?.appCoordinator?.showMainFlow()
    }
}
