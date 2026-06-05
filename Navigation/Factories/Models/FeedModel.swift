import Foundation

class FeedModel {
    
    private let secretWord = "Swift"
    
    var secretWordForDisplay: String {
        return secretWord
    }
    
    func check(word: String) -> Bool {
        return word.lowercased() == secretWord.lowercased()
    }
}
