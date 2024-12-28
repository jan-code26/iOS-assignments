//
//  Claim_table+CoreDataProperties.swift
//  Insurance Policy System application
//
//  Created by jahnavi patel on 11/12/24.
//
//

import Foundation
import CoreData


extension Claim_table {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Claim_table> {
        return NSFetchRequest<Claim_table>(entityName: "Claim_table")
    }

    @NSManaged public var claim_amount: Double
    @NSManaged public var date_of_claim: Date?
    @NSManaged public var id: Int64
    @NSManaged public var status: String?
    @NSManaged public var policy_id: Int64

}

extension Claim_table : Identifiable {

}
