//
//  LoginViewModel.swift
//  AirFiNewsPanel
//
//  Created by Akash Razdan on 21/07/25.
//

import Foundation

enum UserRole {
    case author
    case reviewer
}

class LoginViewModel {
    
    // MARK: - Dependencies
    private let mockService: MockAPIService
    private let repository: ArticleRepository
    
    // MARK: - Init
    init(mockService: MockAPIService = MockAPIService(),
         repository: ArticleRepository = ArticleRepository()) {
        self.mockService = mockService
        self.repository = repository
    }
    
    // MARK: - Constants
    private enum UserDefaultsKeys {
        static let username = "username"
        static let role = "role"
    }
    
    // MARK: - User Role Logic
    func getUserRole(for username: String) -> UserRole {
        return username.lowercased() == "robert" ? .author : .reviewer
    }

    func storeLoginUser(_ username: String) {
        UserDefaults.standard.set(username, forKey: UserDefaultsKeys.username)
        let role = getUserRole(for: username) == .author ? "author" : "reviewer"
        UserDefaults.standard.set(role, forKey: UserDefaultsKeys.role)
    }

    var isDataSynced: Bool {
        return repository.hasArticles()
    }

    // MARK: - Sync Logic

    enum SyncError: Error {
        case network
        case coreData
        case unknown
    }

    /// Syncs article metadata and details from mock API and saves to Core Data.
    func syncData(completion: @escaping (Result<Bool, SyncError>) -> Void) {
        mockService.fetchArticleMetadata { metadataDTOs in
            let group = DispatchGroup()
            var allDetails: [ArticleDetailDTO] = []
            var encounteredError: SyncError?
            let lock = NSLock()

            for dto in metadataDTOs {
                group.enter()
                self.mockService.fetchArticleDetail(by: dto.articleId) { detailDTO in
                    if let detail = detailDTO {
                        let safeCopy = ArticleDetailDTO(
                            articleId: detail.articleId,
                            name: detail.name,
                            article: detail.article,
                            createdAt: detail.createdAt,
                            updatedAt: detail.updatedAt,
                            approvedBy: detail.approvedBy
                        )
                        lock.lock()
                        allDetails.append(safeCopy)
                        lock.unlock()
                    } else {
                        encounteredError = .network
                    }
                    group.leave()
                }
            }

            group.notify(queue: .main) {
                if let error = encounteredError {
                    completion(.failure(error))
                    return
                }

                self.repository.save(metadataList: metadataDTOs, details: allDetails)
                completion(.success(true))
            }
        }
    }

    /// External sync trigger (called from VC)
    func performFullSync(completion: @escaping (Result<Bool, SyncError>) -> Void) {
        syncData(completion: completion)
    }
}
