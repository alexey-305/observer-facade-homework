import UIKit
import CoreData

class FavoritesViewController: UIViewController {
    
    private let coreDataManager = CoreDataManager.shared
    private var favoritePosts: [FavoritePost] = []
    private var isFiltering: Bool = false
    private var currentFilterAuthor: String?
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tv
    }()
    
    // MARK: - Navigation Bar Buttons
    private lazy var filterButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            title: "🔍",
            style: .plain,
            target: self,
            action: #selector(filterButtonTapped)
        )
        return button
    }()
    
    private lazy var clearFilterButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            title: "✖️",
            style: .plain,
            target: self,
            action: #selector(clearFilterTapped)
        )
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Избранное"
        
        setupNavigationBar()
        setupTableView()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    // MARK: - Setup
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItems = [filterButton, clearFilterButton]
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
    
    private func loadData() {
        if isFiltering, let author = currentFilterAuthor {
            favoritePosts = coreDataManager.fetchPosts(byAuthor: author)
        } else {
            favoritePosts = coreDataManager.fetchAllPosts()
        }
        tableView.reloadData()
        
        if favoritePosts.isEmpty {
            showEmptyState()
        } else {
            hideEmptyState()
        }
    }
    
    private func showEmptyState() {
        let label = UILabel()
        label.text = isFiltering ? "Нет постов автора \(currentFilterAuthor ?? "")" : "Нет избранных постов"
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.tag = 999
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func hideEmptyState() {
        view.viewWithTag(999)?.removeFromSuperview()
    }
    
    // MARK: - Filter Actions
    @objc private func filterButtonTapped() {
        let alert = UIAlertController(
            title: "Фильтр по автору",
            message: "Введите имя автора для поиска",
            preferredStyle: .alert
        )
        
        alert.addTextField { textField in
            textField.placeholder = "Имя автора"
            textField.autocapitalizationType = .words
        }
        
        let applyAction = UIAlertAction(title: "Применить", style: .default) { [weak self] _ in
            guard let text = alert.textFields?.first?.text, !text.isEmpty else {
                self?.showAlert(title: "Ошибка", message: "Введите имя автора")
                return
            }
            self?.currentFilterAuthor = text
            self?.isFiltering = true
            self?.loadData()
            self?.title = "Фильтр: \(text)"
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        
        alert.addAction(applyAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    @objc private func clearFilterTapped() {
        isFiltering = false
        currentFilterAuthor = nil
        title = "Избранное"
        loadData()
        
        showAlert(title: "Фильтр снят", message: "Показаны все посты")
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritePosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let post = favoritePosts[indexPath.row]
        
        cell.textLabel?.text = post.titleText ?? "Без названия"
        cell.textLabel?.numberOfLines = 2
        cell.detailTextLabel?.text = "👤 \(post.authorName ?? "Неизвестный") ❤️ \(post.likesCount)"
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Swipe to Delete
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] _, _, completion in
            guard let self = self else {
                completion(false)
                return
            }
            
            let postToDelete = self.favoritePosts[indexPath.row]
            
            // Удаляем из CoreData
            self.coreDataManager.deletePost(postToDelete)
            
            // Удаляем из массива и таблицы
            self.favoritePosts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            // Если после удаления список пуст — показываем empty state
            if self.favoritePosts.isEmpty {
                self.loadData()
            }
            
            completion(true)
        }
        deleteAction.backgroundColor = .red
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}
