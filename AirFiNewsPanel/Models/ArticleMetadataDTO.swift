//
//  ArticleMetadataDTO.swift
//  AirFiNewsPanel
//
//  Created by Akash Razdan on 22/07/25.
//

import Foundation

struct ArticleMetadataDTO: Codable {
    let articleId: String
    let author: String
    let approveCount: Int
}
