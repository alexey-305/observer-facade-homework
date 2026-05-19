import UIKit

final class FeedViewController: UIViewController {
    
    weak var coordinator: FeedCoordinator?
    
    private let secretWord = "Swift"
    
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
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let checkGuessButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Проверить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Feed"
        
        setupViews()
        setupConstraints()
        setupActions()
    }
    
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
        checkGuessButton.addTarget(self, action: #selector(checkGuess), for: .touchUpInside)
    }
    
    enum GuessWordError: Error {
        case emptyWord
        case incorrectWord
    }
    
    private func checkWordWithResult(word: String) -> Result<String, GuessWordError> {
        if word.isEmpty {
            return .failure(.emptyWord)
        }
        if word.lowercased() != secretWord.lowercased() {
            return .failure(.incorrectWord)
        }
        return .success("✅ Верно! Загаданное слово: Swift")
    }
    
    @objc private func checkGuess() {
        guard let guess = guessTextField.text else { return }
        
        let result = checkWordWithResult(word: guess)
        
        switch result {
        case .success(let message):
            resultLabel.text = message
            resultLabel.textColor = .green
        case .failure(let error):
            switch error {
            case .emptyWord:
                resultLabel.text = "Пожалуйста, введите слово"
            case .incorrectWord:
                resultLabel.text = "❌ Неверно! Попробуйте ещё раз"
            }
            resultLabel.textColor = .red
        }
        
        guessTextField.text = ""
    }
}
