//
//  Payment_table+CoreDataProperties.swift
//  Insurance Policy System application
//
//  Created by jahnavi patel on 11/12/24.
//
//

import Foundation
import CoreData


extension Payment_table {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Payment_table> {
        return NSFetchRequest<Payment_table>(entityName: "Payment_table")
    }

    @NSManaged public var id: Int64
    @NSManaged public var payment_amount: Double
    @NSManaged public var payment_date: Date?
    @NSManaged public var payment_method: String?
    @NSManaged public var status: String?
    @NSManaged public var policy_id: Int64

}

extension Payment_table : Identifiable {

}
