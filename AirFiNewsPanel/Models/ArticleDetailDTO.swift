//
//  ArticleDetailDTO.swift
//  AirFiNewsPanel
//
//  Created by Akash Razdan on 22/07/25.
//

import Foundation

struct ArticleDetailDTO: Codable {
    let articleId: String
    let name: String
    let article: String
    let createdAt: String
    let updatedAt: String
    let approvedBy: [String]
}
