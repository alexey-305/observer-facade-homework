import UIKit
import CoreData

class FavoritesViewController: UIViewController {
    
    // MARK: - Properties
    
    private let coreDataManager = CoreDataManager.shared
    private var isFiltering: Bool = false
    private var currentFilterAuthor: String?
    
    // MARK: - FetchedResultsController
    
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
        return controller // performFetch вызывается отдельно в viewDidLoad
    }()
    
    // MARK: - UI Elements
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        // Не регистрируем UITableViewCell.self — используем .subtitle стиль через dequeue вручную
        return tv
    }()
    
    private lazy var filterButton: UIBarButtonItem = {
        UIBarButtonItem(
            title: "🔍",
            style: .plain,
            target: self,
            action: #selector(filterButtonTapped)
        )
    }()
    
    private lazy var clearFilterButton: UIBarButtonItem = {
        UIBarButtonItem(
            title: "✖️",
            style: .plain,
            target: self,
            action: #selector(clearFilterTapped)
        )
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Избранное"
        
        navigationItem.rightBarButtonItems = [filterButton, clearFilterButton]
        
        setupTableView()
        performInitialFetch()
    }
    
    // viewWillAppear убран — FRC сам отслеживает изменения через делегат
    
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
    
    // MARK: - Fetch
    
    /// Первоначальный fetch при загрузке экрана
    private func performInitialFetch() {
        do {
            try fetchedResultsController.performFetch()
            tableView.reloadData()
        } catch {
            print("❌ Ошибка выполнения fetch: \(error)")
        }
    }
    
    /// Обновление предиката и повторный fetch (только при смене фильтра)
    private func updateFetchRequest() {
        if isFiltering, let author = currentFilterAuthor, !author.isEmpty {
            fetchedResultsController.fetchRequest.predicate = NSPredicate(
                format: "authorName CONTAINS[cd] %@", author
            )
        } else {
            fetchedResultsController.fetchRequest.predicate = nil
        }
        
        do {
            try fetchedResultsController.performFetch()
            tableView.reloadData()
        } catch {
            print("❌ Ошибка обновления fetch: \(error)")
        }
    }
    
    // MARK: - Actions
    
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
            guard let self = self,
                  let text = alert.textFields?.first?.text,
                  !text.isEmpty else {
                self?.showAlert(title: "Ошибка", message: "Введите имя автора")
                return
            }
            self.currentFilterAuthor = text
            self.isFiltering = true
            self.title = "Фильтр: \(text)"
            self.updateFetchRequest()
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
        // Используем стиль .subtitle чтобы detailTextLabel отображался
        var cell = tableView.dequeueReusableCell(withIdentifier: "subtitleCell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "subtitleCell")
        }
        
        let post = fetchedResultsController.object(at: indexPath)
        
        cell?.textLabel?.text = post.titleText ?? "Без названия"
        cell?.textLabel?.numberOfLines = 2
        cell?.textLabel?.font = .systemFont(ofSize: 16)
        
        cell?.detailTextLabel?.text = "✍️ \(post.authorName ?? "Неизвестный")  ❤️ \(post.likesCount)"
        cell?.detailTextLabel?.font = .systemFont(ofSize: 12)
        cell?.detailTextLabel?.textColor = .gray
        
        return cell ?? UITableViewCell()
    }
}

// MARK: - UITableViewDelegate

extension FavoritesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: "Удалить"
        ) { [weak self] _, _, completion in
            guard let self = self else {
                completion(false)
                return
            }
            // Объект берётся из FRC — удаляем его через CoreDataManager
            // FRC-делегат автоматически анимирует удаление строки
            let post = self.fetchedResultsController.object(at: indexPath)
            self.coreDataManager.deletePost(post)
            completion(true)
        }
        deleteAction.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension FavoritesViewController: NSFetchedResultsControllerDelegate {
    
    /// Вызывается перед началом изменений — открываем batch-обновление таблицы
    func controllerWillChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>
    ) {
        tableView.beginUpdates()
    }
    
    /// Вызывается после всех изменений — закрываем batch и применяем анимации
    func controllerDidChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>
    ) {
        tableView.endUpdates()
    }
    
    /// Вызывается для каждого изменённого объекта
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
            
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else { return }
            tableView.moveRow(at: indexPath, to: newIndexPath)
            
        @unknown default:
            break
        }
    }
}
