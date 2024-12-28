//
//  CustomerView.swift
//  Insurance Policy Plans
//
//  Created by jahnavi patel on 10/20/24.
//

//1. Customer:
//• Add Customer: Add a new customer by providing the details mentioned above.
//• Update Customer: You can only update the name and age of the customer.
//• Delete a Customer: If a customer has one or more Insurance Policy Plans, you cannot
//delete that customer.
//• View All Customers: Users can view a list of all available customers in the system.

import UIKit

class CustomerView: UIView {
    
    var safeFrame: CGRect
    var parent: MainView?
    
    init() {
        let windowSize = UIApplication.shared.windows[0]
        safeFrame = windowSize.safeAreaLayoutGuide.layoutFrame
        super.init(frame: .zero)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func customerMenu() -> UIView {
        let addCustomerButton: UIButton = {
            let button = UIButton()
            button.setTitle("Add Customer", for: .normal)
            button.frame = CGRect(x: 20, y: 50, width: 160, height: 44)
            button.backgroundColor = .systemBlue
            button.layer.cornerRadius = button.frame.height / 2
            button.clipsToBounds = true
            return button
        }()
        
        let updateCustomerButton: UIButton = {
            let button = UIButton()
            button.setTitle("Update Customer", for: .normal)
            button.frame = CGRect(x: 20, y: 120, width: 160, height: 44)
            button.backgroundColor = .systemBlue
            button.layer.cornerRadius = button.frame.height / 2
            button.clipsToBounds = true
            return button
        }()
        
        let deleteCustomerButton: UIButton = {
            let button = UIButton()
            button.setTitle("Delete Customer", for: .normal)
            button.frame = CGRect(x: 200, y: 50, width: 160, height: 44)
            button.backgroundColor = .systemBlue
            button.layer.cornerRadius = button.frame.height / 2
            button.clipsToBounds = true
            return button
        }()
        
        let viewAllCustomersButton: UIButton = {
            let button = UIButton()
            button.setTitle("All Customers", for: .normal)
            button.frame = CGRect(x: 200, y: 120, width: 160, height: 44)
            button.backgroundColor = .systemBlue
            button.layer.cornerRadius = button.frame.height / 2
            button.clipsToBounds = true
            return button
        }()

        let viewCustomerInsuranceButton: UIButton = {
            let button = UIButton()
            button.setTitle("Customer Insurance", for: .normal)
            button.frame = CGRect(x: 20, y: 190, width: safeFrame.width - 48, height: 44)
            button.backgroundColor = .systemBlue
            button.layer.cornerRadius = button.frame.height / 2
            button.clipsToBounds = true
            return button
        }()
        
        addCustomerButton
            .addTarget(
                self,
                action: #selector(addCustomer),
                for: .touchUpInside
            )
        updateCustomerButton
            .addTarget(
                self,
                action: #selector(updateCustomer),
                for: .touchUpInside
            )
        deleteCustomerButton
            .addTarget(
                self,
                action: #selector(deleteCustomer),
                for: .touchUpInside
            )
        viewAllCustomersButton
            .addTarget(
                self,
                action: #selector(viewAllCustomers),
                for: .touchUpInside
            )
        viewCustomerInsuranceButton
            .addTarget(
                self,
                action: #selector(viewCustomerInsurance),
                for: .touchUpInside
            )
        
        let view = UIView(
            frame: CGRect(x: 0, y: 0, width: safeFrame.width, height: 400))
        view.addSubview(addCustomerButton)
        view.addSubview(updateCustomerButton)
        view.addSubview(deleteCustomerButton)
        view.addSubview(viewAllCustomersButton)
        view.addSubview(viewCustomerInsuranceButton)
        return view
    }
    
    @objc func addCustomer() {
        guard let parent = self.parent else { return }
        parent.outputView.subviews.forEach { $0.removeFromSuperview() }
        
        //        label.text = "Add Customer"
        
        let headerLabel = UILabel(
            frame: CGRect(
                x: 16, y: 10, width: self.safeFrame.width - 32, height: 40)
        )
        headerLabel.text = "Add Customer"
        headerLabel.textAlignment = .center
        headerLabel.font = UIFont.boldSystemFont(ofSize: 20)
        parent.outputView.addSubview(headerLabel)
        
        let nameTextField = UITextField(
            frame: CGRect(
                x: 16, y: 50, width: self.safeFrame.width - 32, height: 44)
        )
        nameTextField.placeholder = "Enter Name"
        nameTextField.borderStyle = .roundedRect
        parent.outputView.addSubview(nameTextField)
        
        let ageTextField = UITextField(
            frame: CGRect(
                x: 16, y: 100, width: self.safeFrame.width - 32, height: 44)
        )
        ageTextField.placeholder = "Enter Age"
        ageTextField.borderStyle = .roundedRect
        parent.outputView.addSubview(ageTextField)
        
        let emailTextField = UITextField(
            frame: CGRect(
                x: 16, y: 150, width: self.safeFrame.width - 32, height: 44)
        )
        emailTextField.placeholder = "Enter Email"
        emailTextField.borderStyle = .roundedRect
        parent.outputView.addSubview(emailTextField)
        
        let addButton = UIButton(
            frame: CGRect(
                x: 16,
                y: 200,
                width: safeFrame.width - 32,
                height: 40
            ),
            primaryAction: UIAction(
                title: "Add Customer",
                handler: { _ in
                    guard let name = nameTextField.text else {
                        self.showAlert(
                            title: "Error", message: "Please enter name")
                        return
                    }
                    guard let age = Int(ageTextField.text ?? "0")
                    else {
                        self.showAlert(
                            title: "Error", message: "Please enter age")
                        return
                    }
                    guard let email = emailTextField.text else {
                        self.showAlert(
                            title: "Error",
                            message: "Please enter email"
                        )
                        return
                    }
                    if( parent.customer.contains(where: { $0.email == emailTextField.text! }) ) {
                                                self.showAlert(
                                                    title: "Error",
                                                    message: "Email already exists"
                                                )
                                                return
                                                }
                    let id = parent.customer.count + 1
                    let newCustomer = Customer(
                        id: id, name: name, age: age, email: email)
                    parent.customer.append(newCustomer)
                    let label = UILabel(
                        frame: CGRect(
                            x: 16, y: 270, width: self.safeFrame.width - 32,
                            height: 40)
                    )
                    self.showAlert(
                        title: "Success", message: "Customer added successfully"
                    )
                    nameTextField.text = ""
                    ageTextField.text = ""
                    emailTextField.text = ""


                }))
        
        addButton.backgroundColor = .systemTeal
        
        parent.outputView.addSubview(addButton)
        
    }
    
    @objc func updateCustomer() {
        guard let parent = self.parent else { return }
        parent.outputView.subviews.forEach { $0.removeFromSuperview() }
        
        let headerLabel = UILabel(
            frame: CGRect(
                x: 16, y: 10, width: self.safeFrame.width - 32, height: 40)
        )
        headerLabel.text = "Update Customer"
        headerLabel.textAlignment = .center
        headerLabel.font = UIFont.boldSystemFont(ofSize: 20)
        parent.outputView.addSubview(headerLabel)
        
        let idTextField = UITextField(
            frame: CGRect(x: 16, y: 50, width: 120, height: 44)
        )
        idTextField.placeholder = "Enter ID"
        idTextField.borderStyle = .roundedRect
        parent.outputView.addSubview(idTextField)
        
        //        fetch customer by id button
        let fetchButton = UIButton(
            frame: CGRect(
                x: 146,
                y: 50,
                width: 200,
                height: 40
            ),
            primaryAction: UIAction(
                title: "Fetch Customer",
                handler: { _ in
                    guard let id = Int(idTextField.text ?? "0") else {
                        self.showAlert(
                            title: "Error", message: "Please enter ID")
                        return
                    }
                    if let customer = parent.customer.first(where: {
                        $0.id == id
                    }) {
                        let nameTextField = UITextField(
                            frame: CGRect(
                                x: 16, y: 150, width: self.safeFrame.width - 32,
                                height: 44)
                        )
                        nameTextField.placeholder = "Enter Name"
                        nameTextField.text = customer.name
                        nameTextField.borderStyle = .roundedRect
                        parent.outputView.addSubview(nameTextField)
                        
                        let ageTextField = UITextField(
                            frame: CGRect(
                                x: 16, y: 200, width: self.safeFrame.width - 32,
                                height: 44)
                        )
                        ageTextField.placeholder = "Enter Age"
                        ageTextField.text = "\(customer.age)"
                        ageTextField.borderStyle = .roundedRect
                        parent.outputView.addSubview(ageTextField)

                        let emailTextField = UITextField(
                            frame: CGRect(
                                x: 16, y: 250, width: self.safeFrame.width - 32,
                                height: 44)
                        )
                        emailTextField.placeholder = "Email"
                        emailTextField.text = customer.email
                        emailTextField.borderStyle = .roundedRect
                        parent.outputView.addSubview(emailTextField)
                        emailTextField.isEnabled = false
                        
                        let updateButton = UIButton(
                            frame: CGRect(
                                x: 16,
                                y: 300,
                                width: self.safeFrame.width - 32,
                                height: 40
                            ),
                            primaryAction: UIAction(
                                title: "Update Customer",
                                handler: { _ in
                                    guard let name = nameTextField.text else {
                                        self.showAlert(
                                            title: "Error",
                                            message: "Please enter name")
                                        return
                                    }
                                    guard
                                        let age = Int(ageTextField.text ?? "0")
                                    else {
                                        self.showAlert(
                                            title: "Error",
                                            message: "Please enter age")
                                        return
                                    }

                                    if let index = parent.customer.firstIndex(
                                        where: { $0.id == id })
                                    {
                                        parent.customer[index].name = name
                                        parent.customer[index].age = age

                                        let label = UILabel(
                                            frame: CGRect(
                                                x: 16, y: 300,
                                                width: self.safeFrame.width
                                                - 32, height: 40)
                                        )
                                        self.showAlert(
                                            title: "Success",
                                            message: "Customer updated successfully"
                                        )
                                        parent.outputView.addSubview(label)
                                    } else {
                                        self.showAlert(
                                            title: "Error",
                                            message: "Customer not found")
                                    }
                                }))
                        
                        updateButton.backgroundColor = .systemGreen
                        parent.outputView.addSubview(updateButton)
                    }
                    else {
                        self.showAlert(
                            title: "Error", message: "Customer not found")
                    }
                }))
        
        fetchButton.backgroundColor = .black
        parent.outputView.addSubview(fetchButton)
        
    }
    
    @objc func deleteCustomer() {
        guard let parent = self.parent else { return }
        parent.outputView.subviews.forEach { $0.removeFromSuperview() }

        let headerLabel = UILabel(
            frame: CGRect(
                x: 16, y: 10, width: self.safeFrame.width - 32, height: 40)
        )
        headerLabel.text = "Delete Customer"
        headerLabel.textAlignment = .center
        headerLabel.font = UIFont.boldSystemFont(ofSize: 20)
        parent.outputView.addSubview(headerLabel)

        
        let idTextField = UITextField(
            frame: CGRect(x: 16, y: 50, width: 120, height: 44)
        )
        idTextField.placeholder = "Enter ID"
        idTextField.borderStyle = .roundedRect
        parent.outputView.addSubview(idTextField)
        
        let deleteButton = UIButton(
            frame: CGRect(
                x: 16,
                y: 100,
                width: safeFrame.width - 32,
                height: 40
            ),
            primaryAction: UIAction(
                title: "Delete Customer",
                handler: { _ in
                    guard let id = Int(idTextField.text ?? "0") else {
                        self.showAlert(
                            title: "Error", message: "Please enter ID")
                        return
                    }
                    if let index = parent.customer.firstIndex(where: {
                        $0.id == id
                    }) {
                        if parent.insurance.first(where: {
                            $0.customer_id == id
                        }) != nil {
                            self.showAlert(
                                title: "Error",
                                message: "Customer has insurance policy plans"
                            )
                        } else {
                            parent.customer.remove(at: index)
                            let label = UILabel(
                                frame: CGRect(
                                    x: 16, y: 150,
                                    width: self.safeFrame.width - 32, height: 40
                                )
                            )
                            self.showAlert(
                                title: "Success",
                                message: "Customer deleted successfully"
                            )
                        }
                    } else {
                        self.showAlert(
                            title: "Error", message: "Customer not found")
                    }
                }))
        
        deleteButton.backgroundColor = .systemRed
        
        parent.outputView.addSubview(deleteButton)
    }
    
    @objc func viewAllCustomers() {
        guard let parent = self.parent else { return }
        parent.outputView.subviews.forEach { $0.removeFromSuperview() }


        let headerLabel = UILabel(
            frame: CGRect(
                x: 16, y: 10, width: self.safeFrame.width - 32, height: 40)
        )
        headerLabel.text = "All Customers"
        headerLabel.textAlignment = .center
        headerLabel.font = UIFont.boldSystemFont(ofSize: 20)
        parent.outputView.addSubview(headerLabel)

        
        var yOffset: CGFloat = 50
        let textViewHeight: CGFloat = 70
         let textViewWidth = self.safeFrame.width - 32

         for customer in parent.customer {
             let textView = UITextView(
                 frame: CGRect(
                     x: 16, y: yOffset, width: textViewWidth,
                     height: textViewHeight)
             )
             textView.text = customer.getCustomerDetails()
             textView.font = UIFont.preferredFont(forTextStyle: .subheadline)
                     textView.isEditable = false
                     textView.layer.borderColor = UIColor.lightGray.cgColor
                     textView.layer.borderWidth = 1.0
                     textView.layer.cornerRadius = 5.0
                     parent.outputView.addSubview(textView)

             yOffset += textViewHeight + 2
         }

        if parent.customer.isEmpty {
            let label = UILabel(
                frame: CGRect(
                    x: 16, y: 50, width: self.safeFrame.width - 32, height: 40)
            )
            label.text = "No customers available"
            label.textAlignment = .center
            parent.outputView.addSubview(label)
        }
        
    }

    @objc func viewCustomerInsurance() {
        guard let parent = self.parent else { return }
        parent.outputView.subviews.forEach { $0.removeFromSuperview() }

        let headerLabel = UILabel(
            frame: CGRect(
                x: 16, y: 10, width: self.safeFrame.width - 32, height: 40)
        )
        headerLabel.text = "Customer Insurance"
        headerLabel.textAlignment = .center
        headerLabel.font = UIFont.boldSystemFont(ofSize: 20)
        parent.outputView.addSubview(headerLabel)

        let idTextField = UITextField(
            frame: CGRect(x: 16, y: 50, width: 120, height: 44)
        )
        idTextField.placeholder = "Enter ID"
        idTextField.borderStyle = .roundedRect
        parent.outputView.addSubview(idTextField)

        let fetchButton = UIButton(
            frame: CGRect(
                x: 146,
                y: 50,
                width: 200,
                height: 40
            ),
            primaryAction: UIAction(
                title: "Fetch Customer",
                handler: { _ in
                    guard let id = Int(idTextField.text ?? "0") else {
                        self.showAlert(
                            title: "Error", message: "Please enter ID")
                        return
                    }
                    if let customer = parent.customer.first(where: {
                        $0.id == id
                    }) {
                    let headerLabel = UILabel(
                                frame: CGRect(
                                    x: 16, y: 110, width: self.safeFrame.width - 32, height: 40)
                            )
                            headerLabel.text = "Customer Insurance"
                            headerLabel.textAlignment = .center
                            headerLabel.font = UIFont.boldSystemFont(ofSize: 20)
                            parent.outputView.addSubview(headerLabel)
                        let textView = UITextView(
                            frame: CGRect(
                                x: 16, y: 150,
                                width: self.safeFrame.width - 32, height: 200)
                        )
                        textView.text = customer.getInsuranceDetails()
                        if textView.text.isEmpty {
                            textView.text = "No insurance policy plans available"
                        }
                        textView.font = UIFont.preferredFont(forTextStyle: .subheadline)
                        textView.isEditable = false
                        textView.layer.borderColor = UIColor.lightGray.cgColor
                        textView.layer.borderWidth = 1.0
                        textView.layer.cornerRadius = 5.0
                        parent.outputView.addSubview(textView)
                    } else {
                        self.showAlert(
                            title: "Error", message: "Customer not found")
                    }
                }))

        fetchButton.backgroundColor = .systemBlue
        parent.outputView.addSubview(fetchButton)
    }
    
    func showAlert(title: String, message: String) {
        let alertView = UIAlertView(
            title: title,
            message: message,
            delegate: self,
            cancelButtonTitle: "Okay")
        alertView.show()
    }
    
}
