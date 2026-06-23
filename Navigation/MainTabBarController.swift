import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupTabBarAppearance()
    }
    
    private func setupTabBarAppearance() {
        // Делаем TabBar видимым и контрастным
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        
        // Цвет для неактивных иконок
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemGray
        ]
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = normalAttributes
        
        // Цвет для активной иконки
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemBlue
        ]
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedAttributes
        
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
        
        // Цвет иконок
        tabBar.tintColor = .systemBlue
        tabBar.unselectedItemTintColor = .systemGray
        tabBar.isTranslucent = false
    }
    
    private func setupTabs() {
        let randomVC = RandomQuoteViewController()
        randomVC.tabBarItem = UITabBarItem(title: "Случайная", image: nil, tag: 0)
        let nav1 = UINavigationController(rootViewController: randomVC)
        
        let allVC = AllQuotesViewController()
        allVC.tabBarItem = UITabBarItem(title: "Все цитаты", image: nil, tag: 1)
        let nav2 = UINavigationController(rootViewController: allVC)
        
        let categoriesVC = CategoriesViewController()
        categoriesVC.tabBarItem = UITabBarItem(title: "Категории", image: nil, tag: 2)
        let nav3 = UINavigationController(rootViewController: categoriesVC)
        
        let feedVC = FeedViewController()
        feedVC.tabBarItem = UITabBarItem(title: "Лента", image: nil, tag: 3)
        let nav4 = UINavigationController(rootViewController: feedVC)
        
        let favoritesVC = FavoritesViewController()
        favoritesVC.tabBarItem = UITabBarItem(title: "Избранное", image: nil, tag: 4)
        let nav5 = UINavigationController(rootViewController: favoritesVC)
        
        viewControllers = [nav1, nav2, nav3, nav4, nav5]
    }
}
