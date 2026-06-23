import UIKit
import CoreData

class FavoritesViewController: UIViewController {
    
    private let coreDataManager = CoreDataManager.shared
    private var isFiltering: Bool = false
    private var currentFilterAuthor: String?
    
    private lazy var fetchedResultsController: NSFetchedResultsController<FavoritePost> = {
        let fetchRequest: NSFetchRequest<FavoritePost> = FavoritePost.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchBatchSize = 20
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: coreDataManager.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        
        do {
            try controller.performFetch()
        } catch {
            print("❌ Ошибка выполнения fetch: \(error)")
        }
        
        return controller
    }()
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tv
    }()
    
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
        
        navigationItem.rightBarButtonItems = [filterButton, clearFilterButton]
        
        setupTableView()
        updateFetchRequest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateFetchRequest()
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
    
    private func updateFetchRequest() {
        let fetchRequest: NSFetchRequest<FavoritePost> = FavoritePost.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchBatchSize = 20
        
        if isFiltering, let author = currentFilterAuthor, !author.isEmpty {
            fetchRequest.predicate = NSPredicate(format: "authorName CONTAINS[cd] %@", author)
        }
        
        fetchedResultsController.fetchRequest.predicate = fetchRequest.predicate
        
        do {
            try fetchedResultsController.performFetch()
            tableView.reloadData()
        } catch {
            print("❌ Ошибка обновления fetch: \(error)")
        }
    }
    
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
            self?.title = "Фильтр: \(text)"
            self?.updateFetchRequest()
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
        updateFetchRequest()
        
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let post = fetchedResultsController.object(at: indexPath)
        
        cell.textLabel?.text = post.titleText ?? "Без названия"
        cell.textLabel?.numberOfLines = 2
        cell.textLabel?.font = .systemFont(ofSize: 16)
        
        // ПОКАЗЫВАЕМ АВТОРА
        cell.detailTextLabel?.text = "✍️ \(post.authorName ?? "Неизвестный")  ❤️ \(post.likesCount)"
        cell.detailTextLabel?.font = .systemFont(ofSize: 12)
        cell.detailTextLabel?.textColor = .gray
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] _, _, completion in
            guard let self = self else {
                completion(false)
                return
            }
            
            let post = self.fetchedResultsController.object(at: indexPath)
            self.coreDataManager.deletePost(post)
            
            completion(true)
        }
        deleteAction.backgroundColor = .red
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension FavoritesViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        case .move:
            if let indexPath = indexPath, let newIndexPath = newIndexPath {
                tableView.moveRow(at: indexPath, to: newIndexPath)
            }
        @unknown default:
            break
        }
    }
}
