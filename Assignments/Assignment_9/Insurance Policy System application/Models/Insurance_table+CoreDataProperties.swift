//
//  Insurance_table+CoreDataProperties.swift
//  Insurance Policy System application
//
//  Created by jahnavi patel on 11/12/24.
//
//

import Foundation
import CoreData


extension Insurance_table {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Insurance_table> {
        return NSFetchRequest<Insurance_table>(entityName: "Insurance_table")
    }

    @NSManaged public var end_date: Date?
    @NSManaged public var id: Int64
    @NSManaged public var policy_type: String?
    @NSManaged public var premium_amount: Double
    @NSManaged public var start_date: Date?
    @NSManaged public var claims: NSSet?
    @NSManaged public var customer_id: Int64
    @NSManaged public var payments: NSSet?

}

// MARK: Generated accessors for claims
extension Insurance_table {

    @objc(addClaimsObject:)
    @NSManaged public func addToClaims(_ value: Claim_table)

    @objc(removeClaimsObject:)
    @NSManaged public func removeFromClaims(_ value: Claim_table)

    @objc(addClaims:)
    @NSManaged public func addToClaims(_ values: NSSet)

    @objc(removeClaims:)
    @NSManaged public func removeFromClaims(_ values: NSSet)

}

// MARK: Generated accessors for payments
extension Insurance_table {

    @objc(addPaymentsObject:)
    @NSManaged public func addToPayments(_ value: Payment_table)

    @objc(removePaymentsObject:)
    @NSManaged public func removeFromPayments(_ value: Payment_table)

    @objc(addPayments:)
    @NSManaged public func addToPayments(_ values: NSSet)

    @objc(removePayments:)
    @NSManaged public func removeFromPayments(_ values: NSSet)

}

extension Insurance_table : Identifiable {

}
