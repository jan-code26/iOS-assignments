//
//  Customer_table+CoreDataClass.swift
//  Insurance Policy System application
//
//  Created by jahnavi patel on 11/12/24.
//
//

import Foundation
import CoreData

enum DecoderConfigurationError: Error {
  case missingManagedObjectContext
}

@objc(Customer_table)
public class Customer_table: NSManagedObject , Decodable{
    enum CodingKeys: CodingKey {
        case id
        case name
        case age
        case email
        case avatarURL
    }
    
    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int64.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.age = try container.decode(Int64.self, forKey: .age)
        self.email = try container.decode(String.self, forKey: .email)
        self.avatarURL = try container.decode(String.self, forKey: .avatarURL)

        
        
    }

}
