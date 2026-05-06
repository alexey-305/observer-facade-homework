import UIKit

class FeedViewController: UIViewController {
    
    // MARK: - Properties
    private let feedModel = FeedModel()
    
    // MARK: - UI Elements
    private let guessTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Угадайте слово..."
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let checkGuessButton: CustomButton = {
        return CustomButton(
            title: "Проверить",
            titleColor: .white,
            backgroundColor: .systemBlue
        )
    }()
    
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.text = "Введите слово и нажмите Проверить"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Feed"
        
        setupViews()
        setupConstraints()
        setupActions()
    }
    
    // MARK: - Setup
    private func setupViews() {
        view.addSubview(guessTextField)
        view.addSubview(checkGuessButton)
        view.addSubview(resultLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            guessTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            guessTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            guessTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            guessTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            guessTextField.heightAnchor.constraint(equalToConstant: 50),
            
            checkGuessButton.topAnchor.constraint(equalTo: guessTextField.bottomAnchor, constant: 20),
            checkGuessButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            checkGuessButton.widthAnchor.constraint(equalToConstant: 200),
            checkGuessButton.heightAnchor.constraint(equalToConstant: 50),
            
            resultLabel.topAnchor.constraint(equalTo: checkGuessButton.bottomAnchor, constant: 30),
            resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupActions() {
        checkGuessButton.action = { [weak self] in
            self?.checkGuess()
        }
    }
    
    // MARK: - Logic
    private func checkGuess() {
        guard let guess = guessTextField.text, !guess.isEmpty else {
            resultLabel.text = "Пожалуйста, введите слово"
            resultLabel.textColor = .red
            return
        }
        
        let isCorrect = feedModel.check(word: guess)
        
        if isCorrect {
            resultLabel.text = "✅ Верно! Загаданное слово: \(feedModel.secretWordForDisplay)"
            resultLabel.textColor = .green
        } else {
            resultLabel.text = "❌ Неверно! Попробуйте ещё раз"
            resultLabel.textColor = .red
        }
        
        guessTextField.text = ""
    }
}
