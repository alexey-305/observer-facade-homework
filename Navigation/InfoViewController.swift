import UIKit

class InfoViewController: UIViewController {
    
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Загрузка..."
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let orbitalPeriodLabel: UILabel = {
        let label = UILabel()
        label.text = "Загрузка..."
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let residentsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ResidentCell")
        tableView.isHidden = true
        return tableView
    }()
    
    private var residents: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Info"
        
        setupViews()
        setupConstraints()
        setupTableView()
        
        fetchTodo()
        fetchAlternativeData()
    }
    
    private func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(orbitalPeriodLabel)
        view.addSubview(residentsTableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            orbitalPeriodLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            orbitalPeriodLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            orbitalPeriodLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            residentsTableView.topAnchor.constraint(equalTo: orbitalPeriodLabel.bottomAnchor, constant: 20),
            residentsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            residentsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            residentsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupTableView() {
        residentsTableView.dataSource = self
        residentsTableView.delegate = self
    }
    
    // MARK: - Задание 1: JSONSerialization
    private func fetchTodo() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Ошибка: \(error)")
                return
            }
            
            guard let data = data else { return }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let title = json["title"] as? String {
                    DispatchQueue.main.async {
                        self.titleLabel.text = title
                    }
                }
            } catch {
                print("❌ Ошибка парсинга: \(error)")
            }
        }
        task.resume()
    }
    
    // MARK: - Альтернативные данные для отображения (вместо swapi)
    private func fetchAlternativeData() {
        // Показываем пример данных, так как swapi.dev не работает
        DispatchQueue.main.async {
            self.orbitalPeriodLabel.text = "Орбитальный период: 304 дня (пример)"
            self.residents = ["Luke Skywalker", "C-3PO", "R2-D2", "Darth Vader", "Leia Organa"]
            self.residentsTableView.reloadData()
            self.residentsTableView.isHidden = false
            print("✅ Отображены примерные данные")
        }
    }
}

extension InfoViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return residents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResidentCell", for: indexPath)
        cell.textLabel?.text = residents[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Жители Татуина (пример)"
    }
}
