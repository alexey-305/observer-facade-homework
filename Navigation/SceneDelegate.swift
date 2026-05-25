import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {

        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }

        let window = UIWindow(windowScene: windowScene)

        let feedViewController = FeedViewController()
        let profileViewController = ProfileViewController()

        let feedNavigationController = UINavigationController(rootViewController: feedViewController)
        let profileNavigationController = UINavigationController(rootViewController: profileViewController)

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [
            feedNavigationController,
            profileNavigationController
        ]

        window.rootViewController = tabBarController

        let configurations: [AppConfiguration] = [

            .people("http://swapi.py4e.com/api/people/8"),
            .starships("http://swapi.py4e.com/api/starships/3"),
            .planets("http://swapi.py4e.com/api/planets/5")
        ]

        let randomConfiguration = configurations.randomElement()

        if let configuration = randomConfiguration {
            NetworkService.request(for: configuration)
        }

        self.window = window
        window.makeKeyAndVisible()
    }
}
