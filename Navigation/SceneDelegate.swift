import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    var appConfiguration: AppConfiguration?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        self.window = window

        let appCoordinator = AppCoordinator(window: window)
        self.appCoordinator = appCoordinator
        appCoordinator.start()

        setupRandomAppConfiguration()
    }

    private func setupRandomAppConfiguration() {
        let randomNumber = Int.random(in: 0...2)

        switch randomNumber {
        case 0:
            appConfiguration = .people("http://swapi.dev/api/people/8")
        case 1:
            appConfiguration = .starships("http://swapi.dev/api/starships/3")
        default:
            appConfiguration = .planets("http://swapi.dev/api/planets/5")
        }

        print("🔧 Случайная конфигурация установлена: \(String(describing: appConfiguration))")

        if let config = appConfiguration {
            NetworkService.request(for: config)
        }
    }
}
