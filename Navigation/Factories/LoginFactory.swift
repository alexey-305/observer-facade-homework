import Foundation

// MARK: - LoginFactory Protocol
protocol LoginFactory {
    func makeLoginInspector() -> LoginInspector
}

// MARK: - MyLoginFactory
struct MyLoginFactory: LoginFactory {
    func makeLoginInspector() -> LoginInspector {
        return LoginInspector()
    }
}
