//
//  Policies_data+CoreDataClass.swift
//  Assignment_10
//
//  Created by jahnavi patel on 11/19/24.
//
//

import Foundation
import CoreData

@objc(Policies_data)
public class Policies_data: NSManagedObject, Decodable,Identifiable {
    enum CodingKeys: CodingKey {
        case id
        case policy_type
        case premium_amount
        case start_date
        case end_date
        case customer_id
    }

    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int64.self, forKey: .id)
        self.policy_type = try container.decode(String.self, forKey: .policy_type)
        self.premium_amount = try container.decode(Double.self, forKey: .premium_amount)
        self.start_date = try container.decode(Date.self, forKey: .start_date)
        self.end_date = try container.decode(Date.self, forKey: .end_date)
        self.customer_id = try container.decode(Int64.self, forKey: .customer_id)
        
      
        
    }
}
