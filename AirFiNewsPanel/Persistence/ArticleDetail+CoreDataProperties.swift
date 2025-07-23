//
//  ArticleDetail+CoreDataProperties.swift
//  AirFiNewsPanel
//
//  Created by Akash Razdan on 22/07/25.
//
//

import Foundation
import CoreData


extension ArticleDetail {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArticleDetail> {
        return NSFetchRequest<ArticleDetail>(entityName: "ArticleDetail")
    }

    @NSManaged public var id: String?
    @NSManaged public var content: String?

}

extension ArticleDetail : Identifiable {

}
