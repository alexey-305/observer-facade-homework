import UIKit

class ProfileCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = ProfileViewModel()
        let profileVC = ProfileViewController()
        profileVC.viewModel = viewModel
        
        navigationController.setViewControllers([profileVC], animated: false)
    }
}
