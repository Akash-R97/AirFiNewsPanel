//
//  ReviewerNewsViewModel.swift
//  AirFiNewsPanel
//
//  Created by Akash Razdan on 22/07/25.
//
import Foundation

class ReviewerNewsViewModel {

    private let repository = ArticleRepository()
    private let grouper = ArticleGrouper()
    private let reviewerName: String

    private var allArticles: [ArticleMetadata] = []
    private let pageSize = 5
    private var currentOffset = 0

    private(set) var groupedArticles: [ArticleGroup] = []
    private(set) var selectedArticleIDs: Set<String> = []

    init(reviewerName: String) {
        self.reviewerName = reviewerName
    }

    // MARK: - Data Loading

    func loadArticles(completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.reloadData()
            DispatchQueue.main.async {
                completion()
            }
        }
    }

    func reloadData() {
        groupedArticles.removeAll()
        selectedArticleIDs.removeAll()
        currentOffset = 0

        allArticles = repository.getAllMetadata()
            .filter { !($0.approvedBy?.contains(self.reviewerName) ?? false) }

        loadAllVisiblePages()
    }

    /// Ensures enough data is loaded to fill the visible area.
    private func loadAllVisiblePages() {
        var loaded = 0
        repeat {
            let batch = Array(allArticles.dropFirst(currentOffset).prefix(pageSize))
            currentOffset += batch.count
            loaded = batch.count

            let newGroups = grouper.group(batch)
            for newGroup in newGroups {
                if let index = groupedArticles.firstIndex(where: { $0.author == newGroup.author }) {
                    groupedArticles[index].articles.append(contentsOf: newGroup.articles)
                } else {
                    groupedArticles.append(newGroup)
                }
            }
        } while loaded == pageSize // Keep loading until batch < pageSize
    }

    func loadNextPage() {
        let nextBatch = Array(allArticles.dropFirst(currentOffset).prefix(pageSize))
        currentOffset += nextBatch.count

        let newGroups = grouper.group(nextBatch)
        for newGroup in newGroups {
            if let index = groupedArticles.firstIndex(where: { $0.author == newGroup.author }) {
                groupedArticles[index].articles.append(contentsOf: newGroup.articles)
            } else {
                groupedArticles.append(newGroup)
            }
        }
    }

    // MARK: - Table Helpers

    var authors: [String] {
        groupedArticles.map { $0.author }
    }

    var articlesByAuthor: [String: [ArticleMetadata]] {
        var dict: [String: [ArticleMetadata]] = [:]
        for group in groupedArticles {
            dict[group.author] = group.articles
        }
        return dict
    }

    func isSelected(_ article: ArticleMetadata) -> Bool {
        guard let id = article.id else { return false }
        return selectedArticleIDs.contains(id)
    }

    func toggleSelection(for article: ArticleMetadata) {
        guard let id = article.id else { return }
        if selectedArticleIDs.contains(id) {
            selectedArticleIDs.remove(id)
        } else {
            selectedArticleIDs.insert(id)
        }
    }

    func markSelectedArticlesApproved() {
        guard !selectedArticleIDs.isEmpty else { return }

        let articlesToApprove = groupedArticles
            .flatMap { $0.articles }
            .filter { selectedArticleIDs.contains($0.id ?? "") }

        repository.markArticlesApproved(articlesToApprove, reviewer: reviewerName)
        selectedArticleIDs.removeAll()

        // Ensure fully reloading with enough rows visible
        reloadData()
    }

    func hasMoreData() -> Bool {
        return currentOffset < allArticles.count
    }
}

