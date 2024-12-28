//
//  ViewController.swift
//  Insurance Policy System application
//
//  Created by jahnavi patel on 10/22/24.
//

import UIKit

class ViewController: UIViewController {
    
    var customer: [Customer] = []
    var insurance: [Insurance] = []
    var claims: [Claims] = []
    var payments: [Payments] = []
    
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        return dateFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Main Menu"
        // Do any additional setup after loading the view.
        generateDummyData()
    }
    
    func generateDummyData() {
        let customer1 = Customer(id: 1, name: "John Doe", age: 30, email: "John@mail.com")
        let customer2 = Customer(id: 2, name: "Jane Doe", age: 25, email: "Jane@mail.com")
        let customer3 = Customer(id: 3, name: "Jim Doe", age: 35, email: "Jim@mail.com")
        
        customer.append(customer1)
        customer.append(customer2)
        customer.append(customer3)
        
        let insurance1 = Insurance(id: 1, customer_id: 1, policy_type: "Health", premium_amount: 100.00, start_date: dateFormatter.date(from: "07-21-2023") ?? Date(), end_date: dateFormatter.date(from: "07-21-2024") ?? Date())
        let insurance2 = Insurance(id: 2, customer_id: 2, policy_type: "Auto", premium_amount: 200.00, start_date: dateFormatter.date(from: "07-21-2024") ?? Date() , end_date: dateFormatter.date(from: "07-21-2025") ?? Date())
        let insurance3 = Insurance(id: 3, customer_id: 3, policy_type: "Home", premium_amount: 300.00, start_date: dateFormatter.date(from: "07-21-2023") ?? Date() , end_date: dateFormatter.date(from: "08-21-2023") ?? Date())
        
        insurance.append(insurance1)
        insurance.append(insurance2)
        insurance.append(insurance3)
        
        customer1.addInsurance(insurance: insurance1)
        customer2.addInsurance(insurance: insurance2)
        customer3.addInsurance(insurance: insurance3)
        
        let claim1 = Claims(id: 1, policy_id: 1, claim_amount: 100.00, date_of_claim: dateFormatter.date(from: "07-21-2023") ?? Date(), status: "Pending")
        let claim2 = Claims(id: 2, policy_id: 2, claim_amount: 200.00, date_of_claim: dateFormatter.date(from: "07-21-2024") ?? Date(), status: "Approved")
        let claim3 = Claims(id: 3, policy_id: 3, claim_amount: 300.00, date_of_claim: dateFormatter.date(from: "07-21-2023") ?? Date(), status: "Rejected")

        claims.append(claim1)
        claims.append(claim2)
        claims.append(claim3)

        insurance1.addClaim(claim: claim1)
        insurance2.addClaim(claim: claim2)
        insurance3.addClaim(claim: claim3)
        
        let payment1 = Payments(id: 1, policy_id: 1, payment_amount: 100.00, payment_date: dateFormatter.date(from: "07-21-2023") ?? Date(),payment_method: "Credit Card",status: "Processed")
        let payment2 = Payments(id: 2, policy_id: 2, payment_amount: 200.00, payment_date: dateFormatter.date(from: "07-21-2024") ?? Date(),payment_method: "Debit Card",status: "Processing")
        let payment3 = Payments(id: 3, policy_id: 3, payment_amount: 300.00, payment_date: dateFormatter.date(from: "07-21-2023") ?? Date(),payment_method: "Net Banking",status: "Failed")

        payments.append(payment1)
        payments.append(payment2)
        payments.append(payment3)

        insurance1.addPayment(payment: payment1)
        insurance2.addPayment(payment: payment2)
        insurance3.addPayment(payment: payment3)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination
        print(destinationVC)
        if let vc = destinationVC as? CustomerTableViewController {
            vc.mainVC = self
        }
        if let vc = destinationVC as? InsuranceTableViewController {
            vc.mainVC = self
        }
        if let vc = destinationVC as? ClaimTableViewController {
            vc.mainVC = self
        }
        if let vc = destinationVC as? PaymentTableViewController {
            vc.mainVC = self
        }
    }
    
    
}

