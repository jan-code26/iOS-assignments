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
    var payments: [Payments] = []
    var claims: [Claims] = []

    init(id: Int, customer_id: Int, policy_type: String, premium_amount: Double, start_date: Date, end_date: Date) {
        self.id = id
        self.customer_id = customer_id
        self.policy_type = policy_type
        self.premium_amount = premium_amount
        self.start_date = start_date
        self.end_date = end_date
        self.payments = []
        self.claims = []
    }

    func getInsuranceDetails() -> String {
        return "Insurance ID: \(id), Customer ID: \(customer_id), Policy Type: \(policy_type), Premium Amount: \(premium_amount), Start Date: \(start_date), End Date: \(end_date)"
    }

    func addPayment(payment: Payments) {
        self.payments.append(payment)
    }

    func removePayment(payment: Payments) {
        if let index = self.payments.firstIndex(where: { $0.id == payment.id }) {
            self.payments.remove(at: index)
        }
    }

    func getPaymentDetails() -> String {
        var paymentDetails = ""
        for payment in self.payments {
            paymentDetails += payment.getPaymentDetails() + "\n"
        }
        return paymentDetails
    }

    func addClaim(claim: Claims) {
        self.claims.append(claim)
    }

    func removeClaim(claim: Claims) {
        if let index = self.claims.firstIndex(where: { $0.id == claim.id }) {
            self.claims.remove(at: index)
        }
    }

    func getClaimDetails() -> String {
        var claimDetails = ""
        for claim in self.claims {
            claimDetails += claim.getClaimDetails() + "\n"
        }
        return claimDetails
    }
}
