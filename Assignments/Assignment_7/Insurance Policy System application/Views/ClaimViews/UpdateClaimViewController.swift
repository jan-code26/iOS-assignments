//
//  UpdateClaimViewController.swift
//  Insurance Policy System application
//
//  Created by jahnavi patel on 10/29/24.
//

import UIKit

class UpdateClaimViewController: UIViewController {

    var mainVC : ViewController?
    var indexPath: IndexPath?

    @IBOutlet weak var policyIDTextField: UITextField!
    @IBOutlet weak var claimAmountTextField: UITextField!
    @IBOutlet weak var dateOfClaimPicker: UIDatePicker!
    @IBOutlet weak var statusTextField: UITextField!

    @IBOutlet weak var button: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Update Claim"
        // Do any additional setup after loading the view.
        let policyID = mainVC?.claims[(indexPath?.row)!].policy_id
        let claim = mainVC?.claims[(indexPath?.row)!]
        let claimAmount = claim?.claim_amount
        let dateOfClaim = claim?.date_of_claim
        let status = claim?.status

        policyIDTextField.text = String(policyID!)
        claimAmountTextField.text = String(claimAmount!)
        dateOfClaimPicker.setDate(dateOfClaim!, animated: true)
        statusTextField.text = status

        policyIDTextField.isEnabled = false
        dateOfClaimPicker.isEnabled = false
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func updateClaim(_ sender: Any) {
        guard let mainVC = self.mainVC,let indexPath = indexPath else { return }
        let claimAmount = claimAmountTextField.text
        let status = statusTextField.text

        if claimAmount == "" || status == "" {
            let alert = UIAlertController(title: "Error", message: "Please fill all the fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }

//        only update status if prev status is pending else dont update
        if mainVC.claims[indexPath.row].status == "Approved" || mainVC.claims[indexPath.row].status == "Rejected" {
            showAlert(title: "Error", message: "Claim status cannot be updated",
                        completion: { self.navigationController?.popViewController(animated: true) })

        }

        // Check if claim amount is a valid non-negative float
        guard let claimAmountDouble = Double(claimAmount!), claimAmountDouble >= 0 else {
            showAlert(title: "Error", message: "Please enter a valid claim amount")
            return
        }

        // Check if status is valid
        let validStatus = ["Pending", "Approved", "Rejected"]
        guard validStatus.contains(status!) else {
            showAlert(title: "Error", message: "Please enter a valid status (Pending, Approved, Rejected)")
            return
        }


        // Update claim
        mainVC.claims[indexPath.row].claim_amount = claimAmountDouble
        mainVC.claims[indexPath.row].status = status!

        // Show success message
        showAlert(title: "Success", message: "Claim updated successfully")
    }

func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                completion?()
            }))
            present(alert, animated: true, completion: nil)
        }
}
