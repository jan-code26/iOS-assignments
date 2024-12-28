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

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Add Payment"
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
        if mainVC?.insurance.first(where: { $0.id == policyIDInt }) == nil {
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
        let id = mainVC?.payments.count ?? 0

        let payment = Payments(id:id+1,policy_id: policyIDInt, payment_amount: paymentAmountDouble, payment_date: paymentDate, payment_method: paymentMethod ?? "Debit Card", status: paymentStatus ?? "Processesing")
        mainVC?.payments.append(payment)
        self.showAlert(title: "Success", message: "Payment added successfully", completion: { self.navigationController?.popViewController(animated: true) })
    }

    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        present(alert, animated: true, completion: nil)
    }

}
