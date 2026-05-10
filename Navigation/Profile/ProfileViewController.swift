import UIKit

class ProfileViewController: UIViewController {
    
    var viewModel: ProfileViewModelProtocol! {
        didSet {
            setupBindings()
        }
    }
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Profile"
        
        setupTableView()
        setupConstraints()
        
        if viewModel == nil {
            viewModel = ProfileViewModel()
        }
        
        viewModel.loadData()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "PostCell")
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 400
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupBindings() {
        viewModel.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}

extension ProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostTableViewCell else {
            return UITableViewCell()
        }
        cell.configPostArray(post: viewModel.posts[indexPath.row])
        return cell
    }
}

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let user = viewModel.user else { return nil }
        let header = ProfileHeaderView()
        header.configure(with: user)
        
        header.onStatusChanged = { [weak self] newStatus in
            self?.viewModel.updateStatus(newStatus)
        }
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 220
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
