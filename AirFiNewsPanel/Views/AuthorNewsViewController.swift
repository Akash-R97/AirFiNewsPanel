//
//  AuthorNewsViewController.swift
//  AirFiNewsPanel
//
//  Created by Akash Razdan on 21/07/25.
//

import UIKit

class AuthorNewsViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Properties
    private let viewModel = AuthorNewsViewModel()
    private var username: String = ""

    private enum UserDefaultsKeys {
        static let username = "username"
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("AuthorNewsViewController loaded")
        username = UserDefaults.standard.string(forKey: UserDefaultsKeys.username) ?? ""
        setupTable()
        loadData()
    }

    // MARK: - Setup
    private func setupTable() {
        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(AuthorNewsTableViewCell.self, forCellReuseIdentifier: AuthorNewsTableViewCell.identifier)

        tableView.separatorStyle = .singleLine
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.tableFooterView = UIView()
    }

    // MARK: - Data Loading
    private func loadData() {
        viewModel.loadArticles(for: username)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    // MARK: - Cleanup
    deinit {
        AutoSyncManager.shared.stopAutoSync()
        print("Auto sync stopped")
    }
}

// MARK: - UITableViewDataSource & Delegate
extension AuthorNewsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.articles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let article = viewModel.articles[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AuthorNewsTableViewCell.identifier, for: indexPath) as? AuthorNewsTableViewCell else {
            return UITableViewCell()
        }

        let desc = article.desc ?? "No description"
        let count = viewModel.approveCount(for: article)
        cell.configure(with: desc, approveCount: count)
        return cell
    }
}
