//
//  AddInsuranceViewController.swift
//  Insurance Policy System application
//
//  Created by jahnavi patel on 10/29/24.
//

import UIKit

class AddInsuranceViewController: UIViewController {
    var mainVC: ViewController?
    
    @IBOutlet weak var customerIDTextField: UITextField!
    @IBOutlet weak var policyTypeTextField: UITextField!
    @IBOutlet weak var premiumAmountTextField: UITextField!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add Insurance"
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func addInsurance(_ sender: Any) {
        let customerID = customerIDTextField.text
        let policyType = policyTypeTextField.text
        let premiumAmount = premiumAmountTextField.text
        let startDate = startDatePicker.date
        let endDate = endDatePicker.date
        
        if customerID == "" || policyType == "" || premiumAmount == "" {
            let alert = UIAlertController(title: "Error", message: "Please fill all the fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        // Check if customer ID is a valid integer
        guard let customerIDInt = Int(customerID!), customerIDInt > 0 else {
            showAlert(title: "Error", message: "Please enter a valid customer ID")
            return
        }
        
        //        check if customer id exists
        if mainVC?.customer_table.first(where: { $0.id == customerIDInt }) == nil {
            showAlert(title: "Error", message: "Customer ID does not exist")
            return
        }
        
        // Check if premium amount is a valid float
        guard let premiumAmountDouble = Double(premiumAmount!), premiumAmountDouble > 0 else {
            showAlert(title: "Error", message: "Please enter a valid premium amount")
            return
        }
        
        // Check if start date is before end date
        if startDate > endDate {
            showAlert(title: "Error", message: "Start date must be before end date")
            return
        }
        
        //        strings that do not have number should not contaion any :
        let number = NSPredicate(format: "SELF MATCHES %@", ".*[0-9]+.*")
        if number.evaluate(with: policyType!) {
            showAlert(title: "Error", message: "Policy type should not contain any numbers")
            return
        }
        
        
        let id = mainVC?.insurance_table.count ?? 0
        
        // Add insurance to the mainVC
        let insurance = Insurance_table(context: mainVC!.managedContext)
        let customer = mainVC?.customer_table.first(where: { $0.id == customerIDInt })
        insurance.id = Int16(id)+1
        insurance.customer_id = customer
        insurance.policy_type = policyType
        insurance.premium_amount = premiumAmountDouble
        insurance.start_date = startDate
        insurance.end_date = endDate
        
        mainVC?.insurance_table.append(insurance)
        
        do {
            try mainVC?.managedContext.save()
        } catch {
            print("Error saving context: \(error)")
            showAlert(title: "Error", message: "Error adding insurance")
            return
        }
        
        // Show success alert
        showAlert(title: "Success", message: "Insurance added successfully",completion: {
            self.navigationController?.popViewController(animated: true)
        })
        
        
        
    }
    
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        present(alert, animated: true, completion: nil)
    }
}
