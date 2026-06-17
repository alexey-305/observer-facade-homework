import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }
    
    private func setupTabs() {
        // 1. Случайная цитата
        let randomVC = RandomQuoteViewController()
        randomVC.tabBarItem = UITabBarItem(title: "Случайная", image: nil, tag: 0)
        let nav1 = UINavigationController(rootViewController: randomVC)
        
        // 2. Все цитаты
        let allVC = AllQuotesViewController()
        allVC.tabBarItem = UITabBarItem(title: "Все цитаты", image: nil, tag: 1)
        let nav2 = UINavigationController(rootViewController: allVC)
        
        // 3. Категории
        let categoriesVC = CategoriesViewController()
        categoriesVC.tabBarItem = UITabBarItem(title: "Категории", image: nil, tag: 2)
        let nav3 = UINavigationController(rootViewController: categoriesVC)
        
        // 4. Лента с постами (НОВАЯ)
        let feedVC = FeedViewController()
        feedVC.tabBarItem = UITabBarItem(title: "Лента", image: nil, tag: 3)
        let nav4 = UINavigationController(rootViewController: feedVC)
        
        // 5. Избранное (НОВАЯ)
        let favoritesVC = FavoritesViewController()
        favoritesVC.tabBarItem = UITabBarItem(title: "Избранное", image: nil, tag: 4)
        let nav5 = UINavigationController(rootViewController: favoritesVC)
        
        viewControllers = [nav1, nav2, nav3, nav4, nav5]
    }
}
