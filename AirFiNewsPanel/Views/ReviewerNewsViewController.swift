//
//  ReviewerNewsViewController.swift
//  AirFiNewsPanel
//
//  Created by Akash Razdan on 21/07/25.
//

import UIKit

class ReviewerNewsViewController: UIViewController {

    private var viewModel: ReviewerNewsViewModel!
    private var tableView: UITableView!
    private var approveButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        let username = UserDefaults.standard.string(forKey: "username") ?? "unknown"
        viewModel = ReviewerNewsViewModel(reviewerName: username)

        fetchData()
    }

    private func setupUI() {
        title = "News Review"
        view.backgroundColor = .white

        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ReviewerNewsTableViewCell.self, forCellReuseIdentifier: ReviewerNewsTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
        view.addSubview(tableView)

        approveButton = UIButton(type: .system)
        approveButton.setTitle("Mark Approve", for: .normal)
        approveButton.backgroundColor = UIColor.systemGreen
        approveButton.setTitleColor(.white, for: .normal)
        approveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        approveButton.layer.cornerRadius = 12
        approveButton.translatesAutoresizingMaskIntoConstraints = false
        approveButton.addTarget(self, action: #selector(markApproveTapped), for: .touchUpInside)
        view.addSubview(approveButton)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: approveButton.topAnchor, constant: -12),

            approveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            approveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            approveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),
            approveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func fetchData() {
        viewModel.loadArticles { [weak self] in
            self?.tableView.reloadData()
            self?.tableView.layoutIfNeeded()
        }
    }

    @objc private func markApproveTapped() {
        viewModel.markSelectedArticlesApproved()
        tableView.reloadData()
        tableView.layoutIfNeeded()
    }
}

// MARK: - UITableViewDelegate & DataSource

extension ReviewerNewsViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.authors.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let author = viewModel.authors[section]
        return viewModel.articlesByAuthor[author]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.authors[section]
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReviewerNewsTableViewCell.identifier, for: indexPath) as? ReviewerNewsTableViewCell else {
            return UITableViewCell()
        }

        let author = viewModel.authors[indexPath.section]
        if let article = viewModel.articlesByAuthor[author]?[indexPath.row] {
            let isChecked = viewModel.isSelected(article)
            cell.configure(with: article, isSelected: isChecked)
            cell.checkboxTapped = { [weak self] in
                self?.viewModel.toggleSelection(for: article)
                self?.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }

        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let visibleHeight = scrollView.frame.size.height

        if offsetY > contentHeight - visibleHeight - 100, viewModel.hasMoreData() {
            viewModel.loadNextPage()
            tableView.reloadData()
            tableView.layoutIfNeeded()
        }
    }
}
