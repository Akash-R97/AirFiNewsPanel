//
//  ArticleGrouper.swift
//  AirFiNewsPanel
//
//  Created by Akash Razdan on 22/07/25.
//

import Foundation

// MARK: - Data Structure

struct ArticleGroup {
    let author: String
    var articles: [ArticleMetadata]
}

// MARK: - Grouper Class

class ArticleGrouper {
    
    /// Groups articles by their author name (case-insensitive).
    /// - Parameter articles: List of ArticleMetadata items.
    /// - Returns: Grouped articles sorted alphabetically by author name.
    func group(_ articles: [ArticleMetadata]) -> [ArticleGroup] {
        let groupedDict = Dictionary(grouping: articles) { article in
            article.author?.trimmingCharacters(in: .whitespacesAndNewlines).capitalized ?? "Unknown"
        }

        let groupedArray = groupedDict.map { ArticleGroup(author: $0.key, articles: $0.value) }

        return groupedArray.sorted { $0.author < $1.author }
    }
}
