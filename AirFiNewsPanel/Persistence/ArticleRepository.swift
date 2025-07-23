//
//  ArticleRepository.swift
//  AirFiNewsPanel
//
//  Created by Akash Razdan on 21/07/25.
//

import Foundation
import CoreData
import UIKit

class ArticleRepository {
    
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext) {
        self.context = context
    }

    // MARK: - Save Fetched Articles from API
    func save(metadataList: [ArticleMetadataDTO], details: [ArticleDetailDTO]) {
        let existingIDs = Set(getAllMetadata().compactMap { $0.id })
        let newMetadata = metadataList.filter { !existingIDs.contains($0.articleId) }

        let detailsDict = Dictionary(uniqueKeysWithValues: details.map { ($0.articleId, $0) })
        let formatter = ISO8601DateFormatter()

        for dto in newMetadata {
            let metadata = ArticleMetadata(context: context)
            metadata.id = dto.articleId
            metadata.author = dto.author

            if let detail = detailsDict[dto.articleId] {
                metadata.desc = detail.name
                metadata.approvedBy = detail.approvedBy
                metadata.createdAt = formatter.date(from: detail.createdAt)
                metadata.updatedAt = formatter.date(from: detail.updatedAt)

                let articleDetail = ArticleDetail(context: context)
                articleDetail.id = detail.articleId
                articleDetail.content = detail.article
            }
        }

        saveContext()
    }

    // MARK: - Fetch All Metadata
    func getAllMetadata() -> [ArticleMetadata] {
        let request: NSFetchRequest<ArticleMetadata> = ArticleMetadata.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Failed to fetch metadata: \(error)")
            return []
        }
    }

    // MARK: - Fetch Article Detail by ID
    func getDetail(for id: String) -> ArticleDetail? {
        let request: NSFetchRequest<ArticleDetail> = ArticleDetail.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        do {
            return try context.fetch(request).first
        } catch {
            print("Failed to fetch detail for ID \(id): \(error)")
            return nil
        }
    }

    // MARK: - Approve Logic
    func markArticlesApproved(_ articles: [ArticleMetadata], reviewer: String) {
        for article in articles {
            var approvedList = article.approvedBy ?? []
            if !approvedList.contains(reviewer) {
                approvedList.append(reviewer)
                article.approvedBy = approvedList
            }
        }
        saveContext()
    }

    // MARK: - Clear All (Use cautiously!)
    func clearAllArticles() {
        let fetchRequest1: NSFetchRequest<NSFetchRequestResult> = ArticleMetadata.fetchRequest()
        let fetchRequest2: NSFetchRequest<NSFetchRequestResult> = ArticleDetail.fetchRequest()

        do {
            try context.execute(NSBatchDeleteRequest(fetchRequest: fetchRequest1))
            try context.execute(NSBatchDeleteRequest(fetchRequest: fetchRequest2))
            saveContext()
        } catch {
            print("Failed to clear articles: \(error)")
        }
    }

    // MARK: - Metadata Presence Check
    func hasArticles() -> Bool {
        let request: NSFetchRequest<ArticleMetadata> = ArticleMetadata.fetchRequest()
        request.fetchLimit = 1
        do {
            let count = try context.count(for: request)
            return count > 0
        } catch {
            print("Failed to check if articles exist: \(error)")
            return false
        }
    }

    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
}
