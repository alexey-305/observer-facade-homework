import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }
    
    private func setupTabs() {
        let randomVC = RandomQuoteViewController()
        randomVC.tabBarItem = UITabBarItem(title: "Случайная", image: nil, tag: 0)
        
        let allVC = AllQuotesViewController()
        allVC.tabBarItem = UITabBarItem(title: "Все цитаты", image: nil, tag: 1)
        
        let categoriesVC = CategoriesViewController()
        categoriesVC.tabBarItem = UITabBarItem(title: "Категории", image: nil, tag: 2)
        
        let nav1 = UINavigationController(rootViewController: randomVC)
        let nav2 = UINavigationController(rootViewController: allVC)
        let nav3 = UINavigationController(rootViewController: categoriesVC)
        
        viewControllers = [nav1, nav2, nav3]
    }
}
