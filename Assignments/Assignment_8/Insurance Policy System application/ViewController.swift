//
//  ViewController.swift
//  Insurance Policy System application
//
//  Created by jahnavi patel on 10/22/24.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    
    var customer_table =  [Customer_table]()
    var insurance_table = [Insurance_table]()
    var claim_table = [Claim_table]()
    var payment_table = [Payment_table]()
    
    var managedContext: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext ?? NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        return dateFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Main Menu"
        // Do any additional setup after loading the view.
        //        generateDummyData()
        if !UserDefaults.standard.bool(forKey: "isDummyDataGenerated") {
            generateDummyData()
            UserDefaults.standard.set(true, forKey: "isDummyDataGenerated")
        }
        loadAllData()
    }
    
    func generateDummyData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let customer1 = Customer_table(context: context)
        customer1.id = 1
        customer1.name = "John Doe"
        customer1.age = 30
        customer1.email = "John@mail.com"
        
        let customer2 = Customer_table(context: context)
        customer2.id = 2
        customer2.name = "Jane Doe"
        customer2.age = 25
        customer2.email = "Jane@mail.com"
        
        let customer3 = Customer_table(context: context)
        customer3.id = 3
        customer3.name = "Jim Doe"
        customer3.age = 35
        customer3.email = "Jim@mail.com"
        
        let insurance1 = Insurance_table(context: context)
        insurance1.id = 1
        insurance1.customer_id = customer1
        insurance1.policy_type = "Health"
        insurance1.premium_amount = 100.00
        insurance1.start_date = dateFormatter.date(from: "07-21-2023") ?? Date()
        insurance1.end_date = dateFormatter.date(from: "07-21-2024") ?? Date()
        customer1.insurance = [insurance1]
        
        
        let insurance2 = Insurance_table(context: context)
        insurance2.id = 2
        insurance2.customer_id = customer2
        insurance2.policy_type = "Auto"
        insurance2.premium_amount = 200.00
        insurance2.start_date = dateFormatter.date(from: "07-21-2024") ?? Date()
        insurance2.end_date = dateFormatter.date(from: "07-21-2025") ?? Date()
        customer2.insurance = [insurance2]
        
        let insurance3 = Insurance_table(context: context)
        insurance3.id = 3
        insurance3.customer_id = customer3
        insurance3.policy_type = "Home"
        insurance3.premium_amount = 300.00
        insurance3.start_date = dateFormatter.date(from: "07-21-2023") ?? Date()
        insurance3.end_date = dateFormatter.date(from: "08-21-2023") ?? Date()
        customer3.insurance = [insurance3]
        
        let claim1 = Claim_table(context: context)
        claim1.id = 1
        claim1.policy_id = insurance1
        claim1.claim_amount = 100.00
        claim1.date_of_claim = dateFormatter.date(from: "07-21-2023") ?? Date()
        claim1.status = "Pending"
        insurance1.claims = [claim1]
        
        let claim2 = Claim_table(context: context)
        claim2.id = 2
        claim2.policy_id = insurance2
        claim2.claim_amount = 200.00
        claim2.date_of_claim = dateFormatter.date(from: "07-21-2024") ?? Date()
        claim2.status = "Approved"
        insurance2.claims = [claim2]
        
        let claim3 = Claim_table(context: context)
        claim3.id = 3
        claim3.policy_id = insurance3
        claim3.claim_amount = 300.00
        claim3.date_of_claim = dateFormatter.date(from: "07-21-2023") ?? Date()
        claim3.status = "Rejected"
        insurance3.claims = [claim3]
        
        let payment1 = Payment_table(context: context)
        payment1.id = 1
        payment1.policy_id = insurance1
        payment1.payment_amount = 100.00
        payment1.payment_date = dateFormatter.date(from: "07-21-2023") ?? Date()
        payment1.payment_method = "Credit Card"
        payment1.status = "Processed"
        insurance1.payments = [payment1]
        
        let payment2 = Payment_table(context: context)
        payment2.id = 2
        payment2.policy_id = insurance2
        payment2.payment_amount = 200.00
        payment2.payment_date = dateFormatter.date(from: "07-21-2024") ?? Date()
        payment2.payment_method = "Debit Card"
        payment2.status = "Processing"
        insurance2.payments = [payment2]
        
        let payment3 = Payment_table(context: context)
        payment3.id = 3
        payment3.policy_id = insurance3
        payment3.payment_amount = 300.00
        payment3.payment_date = dateFormatter.date(from: "07-21-2023") ?? Date()
        payment3.payment_method = "Net Banking"
        payment3.status = "Failed"
        insurance3.payments = [payment3]
        
        do {
            try context.save()
        } catch {
            print("Failed to save data: \(error)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination
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
    
    
    func loadAllData() {
        // Fetch Customer_table data
        let customerFetchRequest: NSFetchRequest<Customer_table> = Customer_table.fetchRequest()
        let customerSortDescriptor = NSSortDescriptor(key: "name", ascending: false)
        customerFetchRequest.sortDescriptors = [customerSortDescriptor]
        
        // Fetch Insurance_table data
        let insuranceFetchRequest: NSFetchRequest<Insurance_table> = Insurance_table.fetchRequest()
        let insuranceSortDescriptor = NSSortDescriptor(key: "policy_type", ascending: true)
        insuranceFetchRequest.sortDescriptors = [insuranceSortDescriptor]
        
        // Fetch Claim_table data
        let claimFetchRequest: NSFetchRequest<Claim_table> = Claim_table.fetchRequest()
        let claimSortDescriptor = NSSortDescriptor(key: "date_of_claim", ascending: false)
        claimFetchRequest.sortDescriptors = [claimSortDescriptor]
        
        // Fetch Payment_table data
        let paymentFetchRequest: NSFetchRequest<Payment_table> = Payment_table.fetchRequest()
        let paymentSortDescriptor = NSSortDescriptor(key: "payment_date", ascending: false)
        paymentFetchRequest.sortDescriptors = [paymentSortDescriptor]
        
        do {
            self.customer_table = try self.managedContext.fetch(customerFetchRequest)
            self.insurance_table = try self.managedContext.fetch(insuranceFetchRequest)
            self.claim_table = try self.managedContext.fetch(claimFetchRequest)
            self.payment_table = try self.managedContext.fetch(paymentFetchRequest)
        } catch {
            fatalError("Failed to fetch data: \(error)")
        }
    }
    
}

