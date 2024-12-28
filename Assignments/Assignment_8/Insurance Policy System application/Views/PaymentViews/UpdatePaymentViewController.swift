//
//  UpdatePaymentViewController.swift
//  Insurance Policy System application
//
//  Created by jahnavi patel on 10/29/24.
//

import UIKit

class UpdatePaymentViewController: UIViewController {
    var mainVC : ViewController?
    var indexPath: IndexPath?
    
    @IBOutlet weak var policyIDTextField: UITextField!
    @IBOutlet weak var paymentAmountTextField: UITextField!
    @IBOutlet weak var paymentDatePicker: UIDatePicker!
    @IBOutlet weak var paymentStatusTextField: UITextField!
    @IBOutlet weak var paymentMethodTextField: UITextField!
    
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Update Payment"
        // Do any additional setup after loading the view.
        let payment = mainVC?.payment_table[(indexPath?.row)!]
        let paymentAmount = payment?.payment_amount
        let paymentDate = payment?.payment_date
        let paymentStatus = payment?.status
        let paymentMethod = payment?.payment_method
        let insuance = payment?.policy_id
        let policyID = insuance?.id
        
        policyIDTextField.text = String(policyID!)
        paymentAmountTextField.text = String(paymentAmount!)
        paymentDatePicker.setDate(paymentDate!, animated: true)
        paymentStatusTextField.text = paymentStatus
        paymentMethodTextField.text = paymentMethod
        
        policyIDTextField.isEnabled = false
        paymentDatePicker.isEnabled = false
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func updatePayment(_ sender: Any) {
        guard let mainVC = self.mainVC,let indexPath = indexPath else { return }
        let paymentAmount = paymentAmountTextField.text
        let paymentStatus = paymentStatusTextField.text
        let paymentMethod = paymentMethodTextField.text
        
        if paymentAmount == "" || paymentStatus == "" || paymentMethod == "" {
            let alert = UIAlertController(title: "Error", message: "Please fill all the fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        // Check if payment amount is a valid double
        guard let paymentAmountDouble = Double(paymentAmount!), paymentAmountDouble > 0 else {
            showAlert(title: "Error", message: "Please enter a valid payment amount")
            return
        }
        
        
        // Check if payment method is valid
        let validMethods = ["Debit Card", "Credit Card", "Net Banking", "UPI", "Other"]
        if !validMethods.contains(paymentMethod!) {
            showAlert(title: "Error", message: "Please enter a valid payment method (Debit Card/Credit Card/Net Banking/UPI/Other)")
            return
        }
        
        //        status can only be Processing or Processed
        let validStatus = ["Processing", "Processed", "Failed"]
        if !validStatus.contains(paymentStatus!) {
            showAlert(title: "Error", message: "Please enter a valid status (Processing/Processed/Failed)")
            return
        }
        
        // Update payment
        let payment = mainVC.payment_table[indexPath.row]
        payment.payment_amount = paymentAmountDouble
        payment.status = paymentStatus!
        payment.payment_method = paymentMethod!
        
        do{
            try mainVC.managedContext.save()
        } catch {
            showAlert(title: "Error", message: "Failed to update payment")
            return
        }
        // Show alert
        showAlert(title: "Success", message: "Payment updated successfully"
                  , completion: { self.navigationController?.popViewController(animated: true) })
    }
    
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        present(alert, animated: true, completion: nil)
    }
    
}
