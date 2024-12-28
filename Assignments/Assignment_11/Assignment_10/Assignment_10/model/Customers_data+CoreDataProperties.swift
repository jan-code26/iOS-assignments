//
//  Customers_data+CoreDataProperties.swift
//  Assignment_10
//
//  Created by jahnavi patel on 11/19/24.
//
//

import Foundation
import CoreData


extension Customers_data {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Customers_data> {
        return NSFetchRequest<Customers_data>(entityName: "Customers_data")
    }

    @NSManaged public var age: Int64
    @NSManaged public var avatar: String?
    @NSManaged public var avatar_image: Data?
    @NSManaged public var email: String?
    @NSManaged public var id: Int64
    @NSManaged public var name: String?

}

extension Customers_data : Identifiable {

}
