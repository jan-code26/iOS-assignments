//
//  InsuranceView.swift
//  Insurance Policy Plans
//
//  Created by jahnavi patel on 10/20/24.
//

//2. Insurance Policy Plan:
//• Add Insurance Policy Plan: Add a new insurance plan by providing the details mentioned
//above.
//• Update Insurance Policy Plan: You can only update the policy type, premium amount,
//and end date of an insurance policy.
//• Delete an Insurance Policy Plan: You cannot delete an insurance plan that is still active
//(i.e., the current date is before the end date).
//• View All Insurance Policy Plans: Users can view a list of all insurance plans currently
//available in the system.

import UIKit

class InsuranceView: UIView{
    
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
    
    func insuranceMenu() -> UIView {
        
        
        
        let addInsuranceButton : UIButton = {
            let button = UIButton()
            button.setTitle("Add Insurance", for: .normal)
            button.frame = CGRect(x: 20, y: 50, width: 160, height: 44)
            button.backgroundColor = .systemBlue
            button.layer.cornerRadius = button.frame.height / 2
            button.clipsToBounds = true
            button.addTarget(self, action: #selector(addInsurance), for: .touchUpInside)
            return button
        }()
        
        let updateInsuranceButton : UIButton = {
            let button = UIButton()
            button.setTitle("Update Insurance", for: .normal)
            button.frame = CGRect(x: 20, y: 120, width: 160, height: 44)
            button.backgroundColor = .systemBlue
            button.layer.cornerRadius = button.frame.height / 2
            button.clipsToBounds = true
            button.addTarget(self, action: #selector(updateInsurance), for: .touchUpInside)
            return button
        }()
        
        let deleteInsuranceButton : UIButton = {
            let button = UIButton()
            button.setTitle("Delete Insurance", for: .normal)
            button.frame = CGRect(x: 200, y: 50, width: 160, height: 44)
            button.backgroundColor = .systemBlue
            button.layer.cornerRadius = button.frame.height / 2
            button.clipsToBounds = true
            button.addTarget(self, action: #selector(deleteInsurance), for: .touchUpInside)
            return button
        }()
        
        let viewInsuranceButton : UIButton = {
            let button = UIButton()
            button.setTitle("View Insurance", for: .normal)
            button.frame = CGRect(x: 200, y: 120, width: 160, height: 44)
            button.backgroundColor = .systemBlue
            button.layer.cornerRadius = button.frame.height / 2
            button.clipsToBounds = true
            button.addTarget(self, action: #selector(viewInsurance), for: .touchUpInside)
            return button
        }()
        
        addInsuranceButton.addTarget(self, action: #selector(addInsurance), for: .touchUpInside)
        updateInsuranceButton.addTarget(self, action: #selector(updateInsurance), for: .touchUpInside)
        deleteInsuranceButton.addTarget(self, action: #selector(deleteInsurance), for: .touchUpInside)
        viewInsuranceButton.addTarget(self, action: #selector(viewInsurance), for: .touchUpInside)
        
        let view = UIView(
            frame: CGRect(x: 0, y: 0, width: safeFrame.width, height: 300))
        
        view.addSubview(addInsuranceButton)
        view.addSubview(updateInsuranceButton)
        view.addSubview(deleteInsuranceButton)
        view.addSubview(viewInsuranceButton)
        return view
        
        
    }
    
    @objc func addInsurance() {
        guard let parent = self.parent else { return }
        parent.outputView.subviews.forEach { $0.removeFromSuperview() }
        
        let headerLabel = UILabel(frame: CGRect(x: 16, y: 10, width: self.safeFrame.width - 32, height: 40))
        headerLabel.text = "Add Insurance"
        headerLabel.textAlignment = .center
        headerLabel.font = UIFont.boldSystemFont(ofSize: 20)
        parent.outputView.addSubview(headerLabel)
        
        let policyTypeTextField = UITextField(frame: CGRect(x: 16, y: 50, width: self.safeFrame.width - 32, height: 44))
        policyTypeTextField.placeholder = "Enter Policy Type"
        policyTypeTextField.borderStyle = .roundedRect
        parent.outputView.addSubview(policyTypeTextField)
        
        let premiumAmountTextField = UITextField(frame: CGRect(x: 16, y: 100, width: self.safeFrame.width - 32, height: 44))
        premiumAmountTextField.placeholder = "Enter Premium Amount"
        premiumAmountTextField.borderStyle = .roundedRect
        parent.outputView.addSubview(premiumAmountTextField)

        let customerIDTextField = UITextField(frame: CGRect(x: 16, y: 150, width: self.safeFrame.width - 32, height: 44))
        customerIDTextField.placeholder = "Enter Customer ID"
        customerIDTextField.borderStyle = .roundedRect
        parent.outputView.addSubview(customerIDTextField)

        let startDateTextField = UITextField(frame: CGRect(x: 16, y: 200, width: self.safeFrame.width - 32, height: 44))
        startDateTextField.placeholder = "Enter Start Date"
        startDateTextField.borderStyle = .roundedRect
        parent.outputView.addSubview(startDateTextField)
        
        let endDateTextField = UITextField(frame: CGRect(x: 16, y: 250, width: self.safeFrame.width - 32, height: 44))
        endDateTextField.placeholder = "Enter End Date"
        endDateTextField.borderStyle = .roundedRect
        parent.outputView.addSubview(endDateTextField)
        
        let addButton = UIButton(frame: CGRect(x: 16, y: 300, width: safeFrame.width - 32, height: 40), primaryAction: UIAction(title: "Add Insurance", handler: { _ in
            guard let policyType = policyTypeTextField.text else {
                self.showAlert(title: "Error", message: "Please enter policy type")
                return
            }
            guard let premiumAmount = Double(premiumAmountTextField.text ?? "0") else {
                self.showAlert(title: "Error", message: "Please enter premium amount")
                return
            }
            guard let customerID = Int(customerIDTextField.text ?? "0")            else {
                self.showAlert(title: "Error", message: "Please enter customer ID")
                return
            }
            if parent.customer.first(where: { $0.id == customerID }) == nil {
                self.showAlert(title: "Error", message: "Customer not found")
                return
            }
            guard let startDateString = startDateTextField.text else {
                self.showAlert(title: "Error", message: "Please enter start date")
                return
            }
            guard let startDate = self.validateDate(enteredDate: startDateString) else {
                self.showAlert(title: "Error", message: "Please enter valid start date")
                return
            }

            guard let endDateString = endDateTextField.text else {
                self.showAlert(title: "Error", message: "Please enter end date")
                return
            }
            guard let endDate = self.validateDate(enteredDate: endDateString) else {
                self.showAlert(title: "Error", message: "Please enter valid end date")
                return
            }

            if startDate > endDate {
                self.showAlert(title: "Error", message: "Start date should be before end date")
                return
            }
            let id = parent.insurance.count + 1
            let newInsurance = Insurance(id: id, customer_id: customerID, policy_type: policyType, premium_amount: premiumAmount, start_date: startDate, end_date: endDate)
//            add insurance to customer
            if let customer = parent.customer.first(where: { $0.id == customerID }) {
                customer.insurance.append(newInsurance)
            }
            parent.insurance.append(newInsurance)
            self.showAlert(title: "Success", message: "Insurance added successfully")
            policyTypeTextField.text = ""
            premiumAmountTextField.text = ""
            customerIDTextField.text = ""
            startDateTextField.text = ""
            endDateTextField.text = ""
        }))
        
        addButton.backgroundColor = .systemTeal
        parent.outputView.addSubview(addButton)
    }
    
    @objc func updateInsurance() {
        guard let parent = self.parent else { return }
        parent.outputView.subviews.forEach { $0.removeFromSuperview() }
        
        let headerLabel = UILabel(frame: CGRect(x: 16, y: 10, width: self.safeFrame.width - 32, height: 40))
        headerLabel.text = "Update Insurance"
        headerLabel.textAlignment = .center
        headerLabel.font = UIFont.boldSystemFont(ofSize: 20)
        parent.outputView.addSubview(headerLabel)
        
        let idTextField = UITextField(frame: CGRect(x: 16, y: 50, width: 120, height: 44))
        idTextField.placeholder = "Enter ID"
        idTextField.borderStyle = .roundedRect
        parent.outputView.addSubview(idTextField)
        
        let fetchButton = UIButton(frame: CGRect(x: 146, y: 50, width: 200, height: 40), primaryAction: UIAction(title: "Fetch Insurance", handler: { _ in
            guard let id = Int(idTextField.text ?? "0") else {
                self.showAlert(title: "Error", message: "Please enter ID")
                return
            }
            if let insurance = parent.insurance.first(where: { $0.id == id }) {
                let policyTypeTextField = UITextField(frame: CGRect(x: 16, y: 150, width: self.safeFrame.width - 32, height: 44))
                policyTypeTextField.placeholder = "Enter Policy Type"
                policyTypeTextField.text = insurance.policy_type
                policyTypeTextField.borderStyle = .roundedRect
                parent.outputView.addSubview(policyTypeTextField)
                
                let premiumAmountTextField = UITextField(frame: CGRect(x: 16, y: 200, width: self.safeFrame.width - 32, height: 44))
                premiumAmountTextField.placeholder = "Enter Premium Amount"
                premiumAmountTextField.text = "\(insurance.premium_amount)"
                premiumAmountTextField.borderStyle = .roundedRect
                parent.outputView.addSubview(premiumAmountTextField)
                
                let endDateTextField = UITextField(frame: CGRect(x: 16, y: 250, width: self.safeFrame.width - 32, height: 44))
                endDateTextField.placeholder = "Enter End Date"
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM-dd-yyyy"
                endDateTextField.text = dateFormatter.string(from: insurance.end_date)
                print(dateFormatter.string(from: insurance.end_date))
                endDateTextField.borderStyle = .roundedRect
                parent.outputView.addSubview(endDateTextField)
                
                let updateButton = UIButton(frame: CGRect(x: 16, y: 300, width: self.safeFrame.width - 32, height: 40), primaryAction: UIAction(title: "Update Insurance", handler: { _ in
                    guard let policyType = policyTypeTextField.text else {
                        self.showAlert(title: "Error", message: "Please enter policy type")
                        return
                    }
                    guard let premiumAmount = Double(premiumAmountTextField.text ?? "0") else {
                        self.showAlert(title: "Error", message: "Please enter premium amount")
                        return
                    }
                    guard let endDateString = endDateTextField.text else {
                        self.showAlert(title: "Error", message: "Please enter end date")
                        return
                    }

                    guard let endDate = self.validateDate(enteredDate: endDateString) else {
                        self.showAlert(title: "Error", message: "Please enter valid end date")
                        return
                    }

                     if endDate < insurance.start_date {
                                            self.showAlert(title: "Error", message: "End date should be after start date")
                                            return
                                        }
                    
                    if let index = parent.insurance.firstIndex(where: { $0.id == id }) {
                        parent.insurance[index].policy_type = policyType
                        parent.insurance[index].premium_amount = premiumAmount
                        parent.insurance[index].end_date = endDate
                        self.showAlert(title: "Success", message: "Insurance updated successfully")
                    } else {
                        self.showAlert(title: "Error", message: "Insurance not found")
                    }
                }))
                
                updateButton.backgroundColor = .systemGreen
                parent.outputView.addSubview(updateButton)
            } else {
                self.showAlert(title: "Error", message: "Insurance not found")
            }
        }))
        
        fetchButton.backgroundColor = .black
        parent.outputView.addSubview(fetchButton)
    }
    
    @objc func deleteInsurance() {
        guard let parent = self.parent else { return }
        parent.outputView.subviews.forEach { $0.removeFromSuperview() }

        let headerLabel = UILabel(frame: CGRect(x: 16, y: 10, width: self.safeFrame.width - 32, height: 40))
                headerLabel.text = "Delete Insurance"
                headerLabel.textAlignment = .center
                headerLabel.font = UIFont.boldSystemFont(ofSize: 20)
                parent.outputView.addSubview(headerLabel)

        let idTextField = UITextField(frame: CGRect(x: 16, y: 50, width: 120, height: 44))
        idTextField.placeholder = "Enter ID"
        idTextField.borderStyle = .roundedRect
        parent.outputView.addSubview(idTextField)
        
        let deleteButton = UIButton(frame: CGRect(x: 16, y: 100, width: safeFrame.width - 32, height: 40), primaryAction: UIAction(title: "Delete Insurance", handler: { _ in
            guard let id = Int(idTextField.text ?? "0") else {
                self.showAlert(title: "Error", message: "Please enter ID")
                return
            }
            if let index = parent.insurance.firstIndex(where: { $0.id == id }) {
                let insurance = parent.insurance[index]
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM-dd-yyyy"
                let currentDate = Date()
                if insurance.end_date > currentDate {
                    self.showAlert(title: "Error", message: "Cannot delete active insurance")
                } else {

//                    delete insurance from customer
                    if let customer = parent.customer.first(where: { $0.id == insurance.customer_id }) {
                        customer.removeInsurance(insurance: insurance)
                    }
                    parent.insurance.remove(at: index)
                    self.showAlert(title: "Success", message: "Insurance deleted successfully")
                }
            } else {
                self.showAlert(title: "Error", message: "Insurance not found")
            }
        }))
        
        deleteButton.backgroundColor = .systemRed
        parent.outputView.addSubview(deleteButton)
    }
    
    @objc func viewInsurance() {
    guard let parent = self.parent else { return }
    parent.outputView.subviews.forEach { $0.removeFromSuperview() }

    let headerLabel = UILabel(frame: CGRect(x: 16, y: 10, width: self.safeFrame.width - 32, height: 40))
            headerLabel.text = "View Insurance"
            headerLabel.textAlignment = .center
            headerLabel.font = UIFont.boldSystemFont(ofSize: 20)
            parent.outputView.addSubview(headerLabel)

    var yOffset: CGFloat = 50
    let textViewHeight: CGFloat = 100
    let textViewWidth = self.safeFrame.width - 32

    for insurance in parent.insurance {
        let textView = UITextView(frame: CGRect(x: 16, y: yOffset, width: textViewWidth, height: textViewHeight))
        textView.text = insurance.getInsuranceDetails()
        textView.font = UIFont.preferredFont(forTextStyle: .subheadline)
        textView.isEditable = false
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 5.0
        parent.outputView.addSubview(textView)

        yOffset += textViewHeight + 2
    }

    if parent.insurance.isEmpty {
        let noInsuranceLabel = UILabel(frame: CGRect(x: 16, y: 50, width: textViewWidth, height: 40))
        noInsuranceLabel.text = "No insurance plans found"
        noInsuranceLabel.textAlignment = .center
        parent.outputView.addSubview(noInsuranceLabel)
    }
}

func validateDate(enteredDate: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        if let validDate = dateFormatter.date(from: enteredDate) {
            return validDate
        }
        return nil
    }
    
    func showAlert(title: String, message: String) {
        let alertView = UIAlertView(title: title, message: message, delegate: self, cancelButtonTitle: "Okay")
        alertView.show()
    }
}
