import UIKit
import CoreData

class FeedViewController: UIViewController {
    
    // MARK: - Properties
    
    private var posts: [Post] = []
    
    // MARK: - UI Elements
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        // Не регистрируем UITableViewCell.self — используем .subtitle через dequeue вручную
        return tv
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Лента"
        
        setupTableView()        // сначала настраиваем таблицу и dataSource
        setupDoubleTapGesture() // потом жест
        loadPosts()             // потом данные
    }
    
    // MARK: - Setup
    
    private func setupTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupDoubleTapGesture() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        tableView.addGestureRecognizer(doubleTap)
    }
    
    // MARK: - Data
    
    private func loadPosts() {
        posts = [
            Post(author: "Алексей", description: "Первый пост в ленте! Сегодня отличная погода ☀️", image: "img1", likes: 5, views: 100),
            Post(author: "Мария", description: "Изучаю Swift и создаю крутые приложения 🚀", image: "img2", likes: 12, views: 250),
            Post(author: "Иван", description: "CoreData — мощный инструмент для хранения данных", image: "img3", likes: 8, views: 180),
            Post(author: "Елена", description: "Realm vs CoreData: что выбрать для проекта? 🤔", image: "img4", likes: 15, views: 320)
        ]
        tableView.reloadData()
    }
    
    // MARK: - Actions
    
    @objc private func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: tableView)
        guard let indexPath = tableView.indexPathForRow(at: point) else { return }
        
        let post = posts[indexPath.row]
        
        // Используем стабильный UUID из модели Post
        let postId = post.id
        
        // Проверка на дубликат инкапсулирована в CoreDataManager
        if CoreDataManager.shared.isPostAlreadySaved(id: postId) {
            showAlert(title: "Уже в избранном", message: "Пост уже сохранён")
            return
        }
        
        CoreDataManager.shared.savePost(
            id: postId,
            title: post.description,
            text: post.description,
            author: post.author,
            likes: post.likes,
            imageName: post.image
        )
        
        showAlert(title: "Добавлено в избранное ❤️", message: "Пост сохранён")
    }
    
    // MARK: - Helpers
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension FeedViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Стиль .subtitle обязателен чтобы detailTextLabel отображался
        var cell = tableView.dequeueReusableCell(withIdentifier: "subtitleCell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "subtitleCell")
        }
        
        let post = posts[indexPath.row]
        
        cell?.textLabel?.text = post.description
        cell?.textLabel?.numberOfLines = 2
        cell?.textLabel?.font = .systemFont(ofSize: 16)
        
        cell?.detailTextLabel?.text = "✍️ \(post.author)  ❤️ \(post.likes)  👁️ \(post.views)"
        cell?.detailTextLabel?.font = .systemFont(ofSize: 12)
        cell?.detailTextLabel?.textColor = .gray
        
        return cell ?? UITableViewCell()
    }
}

// MARK: - UITableViewDelegate

extension FeedViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
