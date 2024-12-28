//
//  Insurance.swift
//  Insurance Policy Plans
//
//  Created by jahnavi patel on 10/20/24.
//

import Foundation

class Insurance {
    var id: Int
    var customer_id: Int
    var policy_type: String
    var premium_amount: Double
    var start_date: Date
    var end_date: Date

    init(id: Int, customer_id: Int, policy_type: String, premium_amount: Double, start_date: Date, end_date: Date) {
        self.id = id
        self.customer_id = customer_id
        self.policy_type = policy_type
        self.premium_amount = premium_amount
        self.start_date = start_date
        self.end_date = end_date
    }

    func getInsuranceDetails() -> String {
        return "Insurance ID: \(id), Customer ID: \(customer_id), Policy Type: \(policy_type), Premium Amount: \(premium_amount), Start Date: \(start_date), End Date: \(end_date)"
    }
}
