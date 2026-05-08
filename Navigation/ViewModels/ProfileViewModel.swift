import Foundation
import UIKit

// MARK: - ProfileViewModel Protocol
protocol ProfileViewModelProtocol: AnyObject {
    var user: User? { get }
    var posts: [Post] { get }
    var onDataUpdated: (() -> Void)? { get set }
    
    func loadData()
    func updateStatus(_ newStatus: String)
}

// MARK: - ProfileViewModel
class ProfileViewModel: ProfileViewModelProtocol {
    
    // MARK: - Properties
    private let userService: UserService
    private let postsService: PostsService
    
    private(set) var user: User? {
        didSet {
            onDataUpdated?()
        }
    }
    
    private(set) var posts: [Post] = [] {
        didSet {
            onDataUpdated?()
        }
    }
    
    var onDataUpdated: (() -> Void)?
    
    // MARK: - Init
    init(userService: UserService = TestUserService(), postsService: PostsService = PostsService()) {
        self.userService = userService
        self.postsService = postsService
    }
    
    // MARK: - Methods
    func loadData() {
        user = userService.user
        posts = postsService.getPosts()
    }
    
    func updateStatus(_ newStatus: String) {
        user?.status = newStatus
        onDataUpdated?()
    }
}

// MARK: - PostsService
class PostsService {
    func getPosts() -> [Post] {
        return [
            Post(author: "cat_lover_2024",
                 description: "Сегодня мой кот поймал солнечного зайчика! 🐱☀️",
                 image: "cat1",
                 likes: 120,
                 views: 456),
            Post(author: "hipster_cat",
                 description: "Новый диван - новое место для сна.",
                 image: "cat2",
                 likes: 89,
                 views: 234),
            Post(author: "crazy_cat_lady",
                 description: "Купила новую игрушку, а кот играет с коробкой.",
                 image: "cat3",
                 likes: 256,
                 views: 789),
            Post(author: "philosopher_cat",
                 description: "Зачем люди ходят на работу?",
                 image: "cat4",
                 likes: 445,
                 views: 1234)
        ]
    }
}
