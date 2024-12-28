//
//  AddCustomerViewController.swift
//  Insurance Policy System application
//
//  Created by jahnavi patel on 10/29/24.
//

import UIKit

class AddCustomerViewController: UIViewController {
    var mainVC : ViewController?
    
    @IBOutlet weak var FirstNameTextField: UITextField!
    @IBOutlet weak var LastNameTextField: UITextField!
    @IBOutlet weak var AgeTextField: UITextField!
    @IBOutlet weak var EmailTextField: UITextField!
    
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add Customer"
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
    
    @IBAction func addCustomer(_ sender: Any) {
        let firstName = FirstNameTextField.text
        let lastName = LastNameTextField.text
        let age = AgeTextField.text
        let email = EmailTextField.text
        
        if firstName == "" || lastName == "" || age == "" || email == "" {
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
        
        // Check if email is valid
        guard isValidEmail(email!) else {
            showAlert(title: "Error", message: "Please enter a valid email")
            return
        }
        
        // Check if email already exists
        guard mainVC?.customer.contains(where: { $0.email == email }) == false else {
            showAlert(title: "Error", message: "Email already exists")
            return
        }

//        check if there is number in name
        let number = NSPredicate(format: "SELF MATCHES %@", ".*[0-9]+.*")
        if number.evaluate(with: firstName) || number.evaluate(with: lastName) {
            showAlert(title: "Error", message: "Name should not contain numbers")
            return
        }
        
        let name = (firstName!.trimmingCharacters(in: .whitespaces) + " " + lastName!.trimmingCharacters(in: .whitespaces))
        
        // add id according to the number of customers
        let id = mainVC?.customer.count ?? 0
        
        let customer = Customer(id: id+1, name: name, age: Int(age!)!, email: email!)
        
        
        mainVC?.customer.append(customer)
        print(mainVC?.customer.count ?? 0)
        self.showAlert(title: "Success", message: "Customer added successfully", completion: {
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
