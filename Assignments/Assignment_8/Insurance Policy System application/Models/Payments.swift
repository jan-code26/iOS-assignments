//
//  Payments.swift
//  Insurance Policy System application
//
//  Created by jahnavi patel on 10/22/24.
//

//Payments
  //•	id: Integer
  //•	policy_id: Integer
  //•	payment_amount: Double
  //•	payment_date: String
  //•	payment_method: String (e.g., Credit Card, Bank Transfer)
  //•	status: String (e.g., Pending, Processed, Failed)

import Foundation

struct Payments {
    var id: Int
    var policy_id: Int
    var payment_amount: Double
    var payment_date: Date
    var payment_method: String
    var status: String

    init(id: Int, policy_id: Int, payment_amount: Double, payment_date: Date, payment_method: String, status: String) {
        self.id = id
        self.policy_id = policy_id
        self.payment_amount = payment_amount
        self.payment_date = payment_date
        self.payment_method = payment_method
        self.status = status
    }

    func getPaymentDetails() -> String {
        return "Payment ID: \(id), Policy ID: \(policy_id), Payment Amount: \(payment_amount), Payment Date: \(payment_date), Payment Method: \(payment_method), Status: \(status)"
    }
}
