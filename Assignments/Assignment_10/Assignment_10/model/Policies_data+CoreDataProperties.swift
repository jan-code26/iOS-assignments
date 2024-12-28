//
//  Policies_data+CoreDataProperties.swift
//  Assignment_10
//
//  Created by jahnavi patel on 11/19/24.
//
//

import Foundation
import CoreData


extension Policies_data {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Policies_data> {
        return NSFetchRequest<Policies_data>(entityName: "Policies_data")
    }

    @NSManaged public var end_date: Date?
    @NSManaged public var id: Int64
    @NSManaged public var policy_type: String?
    @NSManaged public var premium_amount: Double
    @NSManaged public var start_date: Date?
    @NSManaged public var customer_id: Int64

}


