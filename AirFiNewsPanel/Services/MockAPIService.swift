//
//  MockAPIService.swift
//  AirFiNewsPanel
//
//  Created by Akash Razdan on 21/07/25.
//

import Foundation

class MockAPIService {
    
    private let mockMetadataList: [ArticleMetadataDTO] = [
        ArticleMetadataDTO(articleId: "ART001", author: "Robert", approveCount: 5),
        ArticleMetadataDTO(articleId: "ART002", author: "Robert", approveCount: 3),
        ArticleMetadataDTO(articleId: "ART003", author: "Robert", approveCount: 7),
        ArticleMetadataDTO(articleId: "ART004", author: "Amit", approveCount: 2),
        ArticleMetadataDTO(articleId: "ART005", author: "Nina", approveCount: 4),
        ArticleMetadataDTO(articleId: "ART006", author: "Amit", approveCount: 0),
        ArticleMetadataDTO(articleId: "ART007", author: "Robert", approveCount: 1)
    ]
    
    private let mockDetails: [ArticleDetailDTO] = [
        ArticleDetailDTO(
            articleId: "ART001",
            name: "Perfume",
            article: "Perfumes are made from essential oils and aroma compounds.",
            createdAt: "2024-12-01T10:30:00Z",
            updatedAt: "2025-06-25T09:15:00Z",
            approvedBy: ["Mark", "John"]
        ),
        ArticleDetailDTO(
            articleId: "ART002",
            name: "Wireless Connectivity",
            article: "The cabin connectivity system is revolutionizing flights.",
            createdAt: "2025-01-12T14:00:00Z",
            updatedAt: "2025-06-22T11:45:00Z",
            approvedBy: ["John"]
        ),
        ArticleDetailDTO(
            articleId: "ART003",
            name: "Inflight Entertainment",
            article: "New tech brings better inflight experiences.",
            createdAt: "2024-11-21T08:20:00Z",
            updatedAt: "2025-06-18T10:10:00Z",
            approvedBy: ["Mark", "Sarah"]
        ),
        ArticleDetailDTO(
            articleId: "ART004",
            name: "Cabin Pressure Monitoring",
            article: "Advanced sensors monitor and adjust cabin pressure.",
            createdAt: "2025-02-05T09:30:00Z",
            updatedAt: "2025-06-20T10:50:00Z",
            approvedBy: []
        ),
        ArticleDetailDTO(
            articleId: "ART005",
            name: "Eco-Friendly Meals",
            article: "Airlines are using biodegradable packaging for meals.",
            createdAt: "2025-01-10T11:00:00Z",
            updatedAt: "2025-06-19T12:25:00Z",
            approvedBy: ["Emily"]
        ),
        ArticleDetailDTO(
            articleId: "ART006",
            name: "Flight Automation",
            article: "AI is optimizing flight routes and efficiency.",
            createdAt: "2025-03-15T07:45:00Z",
            updatedAt: "2025-06-23T08:00:00Z",
            approvedBy: []
        ),
        ArticleDetailDTO(
            articleId: "ART007",
            name: "Passenger Comfort",
            article: "Cabin redesigns now improve lumbar support and lighting.",
            createdAt: "2025-04-01T15:20:00Z",
            updatedAt: "2025-06-24T13:35:00Z",
            approvedBy: ["Robert"]
        )
    ]
    
    func fetchArticleMetadata(completion: @escaping ([ArticleMetadataDTO]) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) {
            completion(self.mockMetadataList)
        }
    }
    
    func fetchArticleDetail(by id: String, completion: @escaping (ArticleDetailDTO?) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) {
            let detail = self.mockDetails.first { $0.articleId == id }
            completion(detail)
        }
    }
    
    func fetchAllDetails(completion: @escaping ([ArticleDetailDTO]) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) {
            completion(self.mockDetails)
        }
    }
}
