//
//  UpdateCustomerViewController.swift
//  Insurance Policy System application
//
//  Created by jahnavi patel on 10/29/24.
//

import UIKit

class UpdateCustomerViewController: UIViewController {
    var mainVC : ViewController?
    var indexPath: IndexPath?
    
    @IBOutlet weak var FirstNameTextField: UITextField!
    @IBOutlet weak var LastNameTextField: UITextField!
    @IBOutlet weak var AgeTextField: UITextField!
    @IBOutlet weak var EmailTextField: UITextField!
    
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Update Customer"
        // Do any additional setup after loading the view.
        let customer = mainVC?.customer_table[(indexPath?.row)!]
        let name = customer?.name
        let age = customer?.age
        let email = customer?.email
        
        let nameArray = name?.components(separatedBy: " ")
        FirstNameTextField.text = nameArray?[0]
        LastNameTextField.text = nameArray?[1]
        AgeTextField.text = String(age!)
        EmailTextField.text = email
        
        EmailTextField.isEnabled = false
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func updateCustomer(_ sender: Any) {
        let firstName = FirstNameTextField.text
        let lastName = LastNameTextField.text
        let age = AgeTextField.text
        
        if firstName == "" || lastName == "" || age == ""  {
            let alert = UIAlertController(title: "Error", message: "Please fill all the fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        // Check if age is a valid integer
        guard let ageInt = Int(age!), ageInt > 0 else {
            showAlert(title: "Error", message: "Please enter a valid age")
            return
        }
        
        let number = NSPredicate(format: "SELF MATCHES %@", ".*[0-9]+.*")
        if number.evaluate(with: firstName) || number.evaluate(with: lastName) {
            showAlert(title: "Error", message: "Name should not contain numbers")
            return
        }
        
        // Update customer
        let customer = mainVC?.customer_table[(indexPath?.row)!]
        customer?.name = firstName! + " " + lastName!
        customer?.age = Int16(ageInt)
        
        do {
            try mainVC?.managedContext.save()
        } catch {
            print("Error saving context: \(error)")
            showAlert(title: "Error", message: "Error updating customer")
            return
        }
        
        
        
        showAlert(title: "Success", message: "Customer updated successfully",completion: {
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        present(alert, animated: true, completion: nil)
    }
    
}
