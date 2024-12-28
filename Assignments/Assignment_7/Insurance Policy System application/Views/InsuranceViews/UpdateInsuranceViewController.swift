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
        let customerID = mainVC?.insurance[(indexPath?.row)!].customer_id
        let insurance = mainVC?.insurance[(indexPath?.row)!]
        let policyType = insurance?.policy_type
        let premiumAmount = insurance?.premium_amount
        let startDate = insurance?.start_date
        let endDate = insurance?.end_date
        
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
        if mainVC.insurance[(indexPath.row)].start_date > endDate {
            showAlert(title: "Error", message: "Start date must be before end date")
            return
        }
        
        let insurance = mainVC.insurance[(indexPath.row)]
        
        let updatedinsurance = Insurance(id: insurance.id, customer_id: insurance.customer_id, policy_type: policyType!, premium_amount: premiumAmountDouble, start_date: insurance.start_date, end_date: endDate)
              mainVC.insurance[(indexPath.row)] = updatedinsurance
        navigationController?.popViewController(animated: true)
    }

        func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                completion?()
            }))
            present(alert, animated: true, completion: nil)
        }
}
