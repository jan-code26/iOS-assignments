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
//    @IBOutlet weak var avatarURLTextField: UITextField!
    @IBOutlet weak var avatarImageView: UIImageView!

    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add observers for keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        title = "Add Customer"
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
    
    @IBAction func addCustomer(_ sender: Any) {
        let firstName = FirstNameTextField.text
        let lastName = LastNameTextField.text
        let age = AgeTextField.text
        let email = EmailTextField.text
        let avatar = avatarImageView.image?.pngData()
        
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
        guard mainVC?.customer_table.contains(where: { $0.email == email }) == false else {
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
        let id = mainVC?.customer_table.count ?? 0
        
        // Add customer to the mainVC
        let customer = Customer_table(context: mainVC!.managedContext)
        customer.id = Int64(id)+1
        customer.name = name
        customer.age = Int64(ageInt)
        customer.email = email
        customer.avatarImageData = avatar
        
        mainVC?.customer_table.append(customer)
        
        do {
            try mainVC?.managedContext.save()
        } catch {
            print("Failed to save data: \(error)")
        }
        
        // Show success alert
        
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

    @IBAction func selectImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
}

 extension AddCustomerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            avatarImageView.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
}
