//
//  AddPaymentViewController.swift
//  Insurance Policy System application
//
//  Created by jahnavi patel on 10/29/24.
//

import UIKit

class AddPaymentViewController: UIViewController {
    var mainVC : ViewController?
    
    @IBOutlet weak var policyIDTextField: UITextField!
    @IBOutlet weak var paymentAmountTextField: UITextField!
    @IBOutlet weak var paymentDatePicker: UIDatePicker!
    @IBOutlet weak var paymentStatusTextField: UITextField!
    @IBOutlet weak var paymentMethodTextField: UITextField!
    
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add observers for keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        title = "Add Payment"
        // Do any additional setup after loading the view.
    }
    
    deinit {
        // Remove observers
        NotificationCenter.default.removeObserver(self)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func addPayment(_ sender: Any) {
        let policyID = policyIDTextField.text
        let paymentAmount = paymentAmountTextField.text
        let paymentDate = paymentDatePicker.date
        let paymentStatus = paymentStatusTextField.text
        let paymentMethod = paymentMethodTextField.text
        
        if policyID == "" || paymentAmount == "" || paymentStatus == "" || paymentMethod == "" {
            let alert = UIAlertController(title: "Error", message: "Please fill all the fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        // Check if policy ID is a valid integer
        guard let policyIDInt = Int(policyID!), policyIDInt > 0 else {
            showAlert(title: "Error", message: "Please enter a valid policy ID")
            return
        }
        
        //        check if policy id exists
        if mainVC?.insurance_table.first(where: { $0.id == policyIDInt }) == nil {
            showAlert(title: "Error", message: "Policy ID does not exist")
            return
        }
        
        //        check if status is valid
        let validStatus = ["Processing", "Processed", "Failed"]
        if !validStatus.contains(paymentStatus!) {
            showAlert(title: "Error", message: "Please enter a valid status (Processing/Processed/Failed)")
            return
        }
        
        //        check if payment method is valid
        let validPaymentMethod = ["Debit Card", "Credit Card", "Net Banking", "UPI","Other"]
        if !validPaymentMethod.contains(paymentMethod!) {
            showAlert(title: "Error", message: "Please enter a valid payment method (Debit Card/Credit Card/Net Banking/UPI/Other)")
            return
        }
        
        // Check if payment amount is a valid double
        guard let paymentAmountDouble = Double(paymentAmount!), paymentAmountDouble > 0 else {
            showAlert(title: "Error", message: "Please enter a valid payment amount")
            return
        }
        let id = mainVC?.payment_table.count ?? 0
        
        // Add payment to the mainVC
        let payment = Payment_table(context: mainVC!.managedContext)
        payment.id = Int64(id)+1
        payment.policy_id = Int64(policyIDInt)
        payment.payment_amount = paymentAmountDouble
        payment.payment_date = paymentDate
        payment.status = paymentStatus
        payment.payment_method = paymentMethod
        
        mainVC?.payment_table.append(payment)
        
        do {
            try mainVC?.managedContext.save()
        } catch {
            print("Error saving context: \(error)")
            showAlert(title: "Error", message: "Error adding payment")
            return
        }
        
        // Show success alert
        showAlert(title: "Success", message: "Payment added successfully"){
            self.navigationController?.popViewController(animated: true)
            
        }
        
    }
    
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
            scrollView.scrollIndicatorInsets = scrollView.contentInset
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
}
