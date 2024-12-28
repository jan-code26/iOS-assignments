//
//  AddClaimViewController.swift
//  Insurance Policy System application
//
//  Created by jahnavi patel on 10/29/24.
//

import UIKit

class AddClaimViewController: UIViewController {
    var mainVC: ViewController?
    
    @IBOutlet weak var policyIDTextField: UITextField!
    @IBOutlet weak var claimAmountTextField: UITextField!
    @IBOutlet weak var dateOfClaimPicker: UIDatePicker!
    @IBOutlet weak var statusTextField: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!

    
    @IBOutlet weak var button: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add observers for keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        title = "Add Claim"
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
    
    @IBAction func addClaim(_ sender: Any) {
        let policyID = policyIDTextField.text
        let claimAmount = claimAmountTextField.text
        let dateOfClaim = dateOfClaimPicker.date
        let status = statusTextField.text
        
        if policyID == "" || claimAmount == "" || status == "" {
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
        
        // Check if claim amount is a valid double
        guard let claimAmountDouble = Double(claimAmount!), claimAmountDouble > 0 else {
            showAlert(title: "Error", message: "Please enter a valid claim amount")
            return
        }
        
        
        // Check if policy ID exists
        if mainVC?.insurance_table.first(where: { $0.id == policyIDInt }) == nil {
            showAlert(title: "Error", message: "Policy ID does not exist")
            return
        }
        
        // Check if status is valid
        let validStatus = ["Pending", "Approved", "Rejected"]
        guard validStatus.contains(status!) else {
            showAlert(title: "Error", message: "Please enter a valid status (Pending, Approved, Rejected)")
            return
        }
        
        let id = mainVC?.claim_table.count ?? 0
        
        // Add claim to the mainVC
        let claim = Claim_table(context: mainVC!.managedContext)
        claim.id = Int64(id)+1
        claim.policy_id = Int64(policyIDInt)
        claim.claim_amount = claimAmountDouble
        claim.date_of_claim = dateOfClaim
        claim.status = status
        
        mainVC?.claim_table.append(claim)
        
        do {
            try mainVC?.managedContext.save()
        } catch {
            print("Error saving context: \(error)")
            showAlert(title: "Error", message: "Error adding claim")
            return
        }
        
        // Show success alert
        showAlert(title: "Success", message: "Claim added successfully" , completion: {
            self.navigationController?.popViewController(animated: true)
        })
        
        // Clear text fields
        policyIDTextField.text = ""
        claimAmountTextField.text = ""
        statusTextField.text = ""
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
