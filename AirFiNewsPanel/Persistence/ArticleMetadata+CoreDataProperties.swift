//
//  ArticleMetadata+CoreDataProperties.swift
//  AirFiNewsPanel
//
//  Created by Akash Razdan on 22/07/25.
//
//

import Foundation
import CoreData


extension ArticleMetadata {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArticleMetadata> {
        return NSFetchRequest<ArticleMetadata>(entityName: "ArticleMetadata")
    }

    @NSManaged public var id: String?
    @NSManaged public var author: String?
    @NSManaged public var desc: String?
    @NSManaged public var approvedBy: [String]?
    @NSManaged public var createdAt: Date?
    @NSManaged public var updatedAt: Date?

}

extension ArticleMetadata : Identifiable {

}
