//
//  AppDelegate.swift
//  Insurance Policy System application
//
//  Created by jahnavi patel on 10/22/24.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?
    var managedObjectContext: NSManagedObjectContext? = nil
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        managedObjectContext = self.persistentContainer.viewContext
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    lazy var persistentContainer: NSPersistentContainer = {
            // 2
            let container = NSPersistentContainer(name: "Insuarnce Policy System Application")
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            return container
    }()
}

