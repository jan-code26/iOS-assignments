//
//  Customer_table+CoreDataProperties.swift
//  Insurance Policy System application
//
//  Created by jahnavi patel on 11/12/24.
//
//

import Foundation
import CoreData


extension Customer_table {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Customer_table> {
        return NSFetchRequest<Customer_table>(entityName: "Customer_table")
    }

    @NSManaged public var age: Int64
    @NSManaged public var email: String?
    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var avatarURL: String? // Existing property
    @NSManaged public var avatarImageData: Data? // Add this line
    @NSManaged public var insurance: NSSet?

}



extension Customer_table : Identifiable {

}

