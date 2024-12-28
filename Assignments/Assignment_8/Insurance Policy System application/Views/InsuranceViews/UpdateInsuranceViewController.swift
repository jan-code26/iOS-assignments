//
//  UpdateInsuranceViewController.swift
//  Insurance Policy System application
//
//  Created by jahnavi patel on 10/29/24.
//

import UIKit

class UpdateInsuranceViewController: UIViewController {
    var mainVC : ViewController?
    var indexPath: IndexPath?
    
    @IBOutlet weak var customerIDTextField: UITextField!
    @IBOutlet weak var policyTypeTextField: UITextField!
    @IBOutlet weak var premiumAmountTextField: UITextField!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Update Insurance"
        // Do any additional setup after loading the view.
        let insurance = mainVC?.insurance_table[(indexPath?.row)!]
        let policyType = insurance?.policy_type
        let premiumAmount = insurance?.premium_amount
        let startDate = insurance?.start_date
        let endDate = insurance?.end_date
        let customer = insurance?.customer_id
        let customerID = customer?.id
        
        customerIDTextField.text = String(customerID!)
        policyTypeTextField.text = policyType
        premiumAmountTextField.text = String(premiumAmount!)
        startDatePicker.setDate(startDate!, animated: true)
        endDatePicker.setDate(endDate!, animated: true)
        
        customerIDTextField.isEnabled = false
        startDatePicker.isEnabled = false
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func updateInsurance(_ sender: Any) {
        guard let mainVC = self.mainVC,let indexPath = indexPath else { return }
        let policyType = policyTypeTextField.text
        let premiumAmount = premiumAmountTextField.text
        let endDate = endDatePicker.date
        
        if   policyType == "" || premiumAmount == ""  {
            let alert = UIAlertController(title: "Error", message: "Please fill all the fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        
        // Check if premium amount is a valid float
        guard let premiumAmountDouble = Double(premiumAmount!), premiumAmountDouble > 0 else {
            showAlert(title: "Error", message: "Please enter a valid premium amount")
            return
        }
        
        // Check if start date is before end date
        if mainVC.insurance_table[(indexPath.row)].start_date! > endDate {
            showAlert(title: "Error", message: "Start date must be before end date")
            return
        }
        
        // Update insurance
        let insurance = mainVC.insurance_table[(indexPath.row)]
        insurance.policy_type = policyType!
        insurance.premium_amount = premiumAmountDouble
        insurance.end_date = endDate
        
        do{
            try mainVC.managedContext.save()
            
        } catch {
            showAlert(title: "Error", message: "Failed to update insurance")
        }
        showAlert(title: "Success", message: "Insurance updated successfully",
                  completion: { self.navigationController?.popViewController(animated: true) })
        
    }
    
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        present(alert, animated: true, completion: nil)
    }
}
