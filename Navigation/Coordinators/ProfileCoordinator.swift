import UIKit
import FirebaseAuth

final class ProfileCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let email = Auth.auth().currentUser?.email
        let profileVC = ProfileViewController(email: email)
        profileVC.title = "Профиль"
        navigationController.pushViewController(profileVC, animated: true)
    }
}
