//
//  Payment_table+CoreDataClass.swift
//  Insurance Policy System application
//
//  Created by jahnavi patel on 11/12/24.
//
//

import Foundation
import CoreData

@objc(Payment_table)
public class Payment_table: NSManagedObject , Decodable{
    enum CodingKeys: CodingKey {
        case id
        case payment_amount
        case payment_date
        case payment_method
        case status
        case policy_id
    }

    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int64.self, forKey: .id)
        self.payment_amount = try container.decode(Double.self, forKey: .payment_amount)
        self.payment_date = try container.decode(Date.self, forKey: .payment_date)
        self.payment_method = try container.decode(String.self, forKey: .payment_method)
        self.status = try container.decode(String.self, forKey: .status)
        self.policy_id = try container.decode(Int64.self, forKey: .policy_id)

    }

}
