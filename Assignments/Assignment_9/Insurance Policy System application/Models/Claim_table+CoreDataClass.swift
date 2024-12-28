//
//  Claim_table+CoreDataClass.swift
//  Insurance Policy System application
//
//  Created by jahnavi patel on 11/12/24.
//
//

import Foundation
import CoreData

@objc(Claim_table)
public class Claim_table: NSManagedObject, Decodable {

        enum CodingKeys: CodingKey {
            case id
            case claim_amount
            case date_of_claim
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
            self.claim_amount = try container.decode(Double.self, forKey: .claim_amount)
            self.date_of_claim = try container.decode(Date.self, forKey: .date_of_claim)
            self.status = try container.decode(String.self, forKey: .status)
            self.policy_id = try container.decode(Int64.self, forKey: .policy_id)

        }

}
