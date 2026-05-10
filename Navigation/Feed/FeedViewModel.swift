import UIKit

protocol FeedViewModelProtocol {
    
    var resultText: String { get }
    var resultColor: UIColor { get }
    
    var onStateChanged: (() -> Void)? { get set }
    
    func checkGuess(_ word: String)
}

final class FeedViewModel: FeedViewModelProtocol {
    
    // MARK: - Private properties
    
    private let model: FeedModel
    
    // MARK: - Binding
    
    var onStateChanged: (() -> Void)?
    
    // MARK: - Public state
    
    private(set) var resultText: String = ""
    private(set) var resultColor: UIColor = .black
    
    // MARK: - Init
    
    init(model: FeedModel = FeedModel()) {
        self.model = model
    }
    
    // MARK: - Logic
    
    func checkGuess(_ word: String) {
        
        guard !word.isEmpty else {
            resultText = "Пожалуйста, введите слово"
            resultColor = .red
            
            onStateChanged?()
            return
        }
        
        let isCorrect = model.check(word: word)
        
        if isCorrect {
            resultText = "✅ Верно! Загаданное слово: \(model.secretWordForDisplay)"
            resultColor = .green
        } else {
            resultText = "❌ Неверно! Попробуйте ещё раз"
            resultColor = .red
        }
        
        onStateChanged?()
    }
}
