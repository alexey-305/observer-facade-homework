import UIKit
import CoreData

class FeedViewController: UIViewController {
    
    private var posts: [Post] = []
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Лента"
        
        loadPosts()
        setupTableView()
        setupDoubleTapGesture()
    }
    
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
    
    private func loadPosts() {
        posts = [
            Post(author: "Алексей", description: "Первый пост в ленте! Сегодня отличная погода ☀️", image: "img1", likes: 5, views: 100),
            Post(author: "Мария", description: "Изучаю Swift и создаю крутые приложения 🚀", image: "img2", likes: 12, views: 250),
            Post(author: "Иван", description: "CoreData — мощный инструмент для хранения данных", image: "img3", likes: 8, views: 180),
            Post(author: "Елена", description: "Realm vs CoreData: что выбрать для проекта? 🤔", image: "img4", likes: 15, views: 320)
        ]
        tableView.reloadData()
    }
    
    @objc private func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: tableView)
        guard let indexPath = tableView.indexPathForRow(at: point) else { return }
        
        let post = posts[indexPath.row]
        let postId = "\(post.author)_\(post.description)_\(post.image)"
        
        let fetchRequest: NSFetchRequest<FavoritePost> = FavoritePost.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", postId)
        
        do {
            let existing = try CoreDataManager.shared.viewContext.fetch(fetchRequest)
            if !existing.isEmpty {
                showAlert(title: "Уже в избранном", message: "Пост уже сохранён")
                return
            }
        } catch {
            print("Ошибка проверки: \(error)")
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
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let post = posts[indexPath.row]
        
        cell.textLabel?.text = post.description
        cell.textLabel?.numberOfLines = 2
        cell.textLabel?.font = .systemFont(ofSize: 16)
        
        cell.detailTextLabel?.text = "✍️ \(post.author)  ❤️ \(post.likes)  👁️ \(post.views)"
        cell.detailTextLabel?.font = .systemFont(ofSize: 12)
        cell.detailTextLabel?.textColor = .gray
        
        return cell
    }
}

extension FeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
