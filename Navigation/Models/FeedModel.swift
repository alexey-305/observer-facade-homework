import Foundation

class FeedModel {
    
    // MARK: - Properties
    private let secretWord = "Swift"
    
    // MARK: - Public
    var secretWordForDisplay: String {
        return secretWord
    }
    
    // MARK: - Methods
    func check(word: String) -> Bool {
        return word.lowercased() == secretWord.lowercased()
    }
}
