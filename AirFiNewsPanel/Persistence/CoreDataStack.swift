//
//  CoreDataStack.swift
//  AirFiNewsPanel
//
//  Created by Akash Razdan on 21/07/25.
//

import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()

    // MARK: - Persistent Container
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "AirFiNewsPanel")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("❌ Unresolved CoreData error: \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    // MARK: - Main Context Accessor
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // MARK: - Save Support
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("❌ CoreData save error: \(error.localizedDescription)")
            }
        }
    }
}
