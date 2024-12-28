//
//  Customer.swift
//  Insurance Policy Plans
//
//  Created by jahnavi patel on 10/20/24.
//

import Foundation

class Customer {
    var id: Int
    var name: String
    var age: Int
    var email: String
    var insurance: [Insurance] = []

    init(id: Int, name: String, age: Int, email: String) {
        self.id = id
        self.name = name
        self.age = age
        self.email = email
        self.insurance = []
    }

    func getCustomerDetails() -> String {
        return "Customer ID: \(id), Name: \(name), Age: \(age), Email: \(email)"
    }

    func addInsurance(insurance: Insurance) {
        self.insurance.append(insurance)
    }

    func removeInsurance(insurance: Insurance) {
        if let index = self.insurance.firstIndex(where: { $0.id == insurance.id }) {
            self.insurance.remove(at: index)
        }
    }

    func getInsuranceDetails() -> String {
        var insuranceDetails = ""
        for insurance in self.insurance {
            insuranceDetails += insurance.getInsuranceDetails() + "\n"
        }
        return insuranceDetails
    }
}
