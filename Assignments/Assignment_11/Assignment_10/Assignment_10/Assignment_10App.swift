//
//  Assignment_10App.swift
//  Assignment_10
//
//  Created by jahnavi patel on 11/18/24.
//

import SwiftUI

@main
struct Assignment_10App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(
                    \.managedObjectContext,
                    persistenceController.container.viewContext)
        }
    }

}

enum DecoderConfigurationError: Error {
    case missingManagedObjectContext
}

extension CodingUserInfoKey {
    static let managedObjectContext = CodingUserInfoKey(
        rawValue: "managedObjectContext")!
}
