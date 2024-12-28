//
//  Customers_data+CoreDataClass.swift
//  Assignment_10
//
//  Created by jahnavi patel on 11/18/24.
//
//

import CoreData
import Foundation
import UIKit

@objc(Customers_data)
public class Customers_data: NSManagedObject, Decodable {
    enum CodingKeys: CodingKey {
        case id
        case name
        case age
        case email
        case avatar
    }

    required convenience public init(from decoder: Decoder) throws {
        guard
            let context = decoder.userInfo[
                CodingUserInfoKey.managedObjectContext]
                as? NSManagedObjectContext
        else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int64.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.age = try container.decode(Int64.self, forKey: .age)
        self.email = try container.decode(String.self, forKey: .email)
        self.avatar = try container.decode(String.self, forKey: .avatar)


    }
}
