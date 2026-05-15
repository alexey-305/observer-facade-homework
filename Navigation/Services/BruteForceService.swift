import Foundation
import UIKit

class BruteForceService {
    
    private let queue = OperationQueue()
    private var isRunning = false
    var onPasswordFound: ((String) -> Void)?
    var onProgressUpdate: ((String) -> Void)?
    
    func startBruteForce(targetPassword: String) {
        isRunning = true
        
        let operation = BlockOperation { [weak self] in
            guard let self = self else { return }
            
            let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            var currentGuess = ""
            
            for char in characters {
                currentGuess = String(char)
                if self.checkPassword(currentGuess, targetPassword) {
                    self.finish(with: currentGuess)
                    return
                }
                
                for char2 in characters {
                    currentGuess = String(char) + String(char2)
                    if self.checkPassword(currentGuess, targetPassword) {
                        self.finish(with: currentGuess)
                        return
                    }
                    
                    for char3 in characters {
                        currentGuess = String(char) + String(char2) + String(char3)
                        if self.checkPassword(currentGuess, targetPassword) {
                            self.finish(with: currentGuess)
                            return
                        }
                        
                        DispatchQueue.main.async {
                            self.onProgressUpdate?(currentGuess)
                        }
                    }
                }
            }
        }
        
        queue.addOperation(operation)
    }
    
    private func checkPassword(_ guess: String, _ target: String) -> Bool {
        return guess == target
    }
    
    private func finish(with password: String) {
        DispatchQueue.main.async {
            self.onPasswordFound?(password)
        }
        isRunning = false
        queue.cancelAllOperations()
    }
    
    func stopBruteForce() {
        queue.cancelAllOperations()
        isRunning = false
    }
}
