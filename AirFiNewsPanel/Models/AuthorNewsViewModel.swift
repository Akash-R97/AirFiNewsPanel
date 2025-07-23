//
//  AuthorNewsViewModel.swift
//  AirFiNewsPanel
//
//  Created by Akash Razdan on 21/07/25.
//

import Foundation

class AuthorNewsViewModel {

    // MARK: - Properties
    private let repository = ArticleRepository()
    private(set) var articles: [ArticleMetadata] = []

    // MARK: - Load Data
    func loadArticles(for username: String) {
        let allArticles = repository.getAllMetadata()
        self.articles = allArticles.filter { ($0.author?.lowercased() ?? "") == username.lowercased() }
    }

    // MARK: - Approval Info
    func approveCount(for article: ArticleMetadata) -> Int {
        guard let approvedList = article.approvedBy as? [String] else {
            return 0
        }
        return approvedList.count
    }
}
