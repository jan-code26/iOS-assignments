//
//  PersistenceController.swift
//  Assignment_10
//
//  Created by jahnavi patel on 11/18/24.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                // Handle the error gracefully
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}
