//
//  Claims.swift
//  Insurance Policy System application
//
//  Created by jahnavi patel on 10/22/24.
//

//Claims
  //• id: Integer
  //• policy_id: Integer
  //• claim_amount: Double
  //• date_of_claim: String
  //• status: String

import Foundation

struct Claims {
    var id: Int
    var policy_id: Int
    var claim_amount: Double
    var date_of_claim: Date
    var status: String

    init(id: Int, policy_id: Int, claim_amount: Double, date_of_claim: Date, status: String) {
        self.id = id
        self.policy_id = policy_id
        self.claim_amount = claim_amount
        self.date_of_claim = date_of_claim
        self.status = status
    }

    func getClaimDetails() -> String {
        return "Claim ID: \(id), Policy ID: \(policy_id), Claim Amount: \(claim_amount), Date of Claim: \(date_of_claim), Status: \(status)"
    }
}
