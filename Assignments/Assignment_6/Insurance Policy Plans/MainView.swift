//
//  MainView.swift
//  Insurance Policy Plans
//
//  Created by jahnavi patel on 10/20/24.
//

import UIKit

class MainView: UIView {
    var customer: [Customer] = []
    var insurance: [Insurance] = []
    
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        return dateFormatter
    }()
    
    let menuItems = UIView()
    let subMenuItems = UIView()
    
    let customerView = CustomerView()
    let insuranceView = InsuranceView()
    var safeFrame: CGRect
    
    let outputView = UIView()
    init() {
        let windowSize = UIApplication.shared.windows[0]
        safeFrame = windowSize.safeAreaLayoutGuide.layoutFrame
        super.init(frame: .zero)
        
        customerView.parent = self
        insuranceView.parent = self
        
        generateMainMenu()
                 generateDummyData()
        outputView.frame = CGRect(x: 0, y: 300, width: safeFrame.width, height: safeFrame.height - 300)
        
        self.addSubview(outputView)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func generateDummyData() {
        let customer1 = Customer(id: 1, name: "John Doe", age: 30, email: "John@mail.com")
        let customer2 = Customer(id: 2, name: "Jane Doe", age: 25, email: "Jane@mail.com")
        let customer3 = Customer(id: 3, name: "Jim Doe", age: 35, email: "Jim@mail.com")

        customer.append(customer1)
        customer.append(customer2)
        customer.append(customer3)

        let insurance1 = Insurance(id: 1, customer_id: 1, policy_type: "Health", premium_amount: 100.00, start_date: dateFormatter.date(from: "07-21-2023") ?? Date(), end_date: dateFormatter.date(from: "07-21-2024") ?? Date())
        let insurance2 = Insurance(id: 2, customer_id: 2, policy_type: "Auto", premium_amount: 200.00, start_date: dateFormatter.date(from: "07-21-2024") ?? Date() , end_date: dateFormatter.date(from: "07-21-2025") ?? Date())
        let insurance3 = Insurance(id: 3, customer_id: 3, policy_type: "Home", premium_amount: 300.00, start_date: dateFormatter.date(from: "07-21-2023") ?? Date() , end_date: dateFormatter.date(from: "08-21-2023") ?? Date())

        insurance.append(insurance1)
        insurance.append(insurance2)
        insurance.append(insurance3)

        customer1.addInsurance(insurance: insurance1)
        customer2.addInsurance(insurance: insurance2)
        customer3.addInsurance(insurance: insurance3)

    }
    
    func generateMainMenu() {

     let headerLabel = UILabel(
                frame: CGRect(x: 0, y: 0, width: safeFrame.width, height: 20))
            headerLabel.text = "Insurance Policy Plans"
            headerLabel.textAlignment = .center
            headerLabel.backgroundColor = .systemBlue
            headerLabel.textColor = .white
        
        let customerMenuButton : UIButton = {
            let button = UIButton()
            button.setTitle("Customer", for: .normal)
            button.frame = CGRect(x: 16, y: 10, width: 90, height: 44)
            button.backgroundColor = .systemBlue
            button.layer.cornerRadius = button.frame.height / 2
            button.clipsToBounds = true
            return button
        }()
        
        
        let insuranceMenuButton : UIButton = {
            let button = UIButton()
            button.setTitle("Insurance", for: .normal)
            button.frame = CGRect(x: 126, y: 10, width: 90, height: 44)
            button.backgroundColor = .systemBlue
            button.layer.cornerRadius = button.frame.height / 2
            button.clipsToBounds = true
            return button
        }()

        let CloseButton : UIButton = {
            let button = UIButton()
            button.setTitle("Close", for: .normal)
            button.frame = CGRect(x: 236, y: 10, width: 90, height: 44)
            button.backgroundColor = .systemBlue
            button.layer.cornerRadius = button.frame.height / 2
            button.clipsToBounds = true
            return button
        }()
        
        menuItems.addSubview(customerMenuButton)
        menuItems.addSubview(insuranceMenuButton)
        menuItems.addSubview(CloseButton)

        self.addSubview(headerLabel)
        self.addSubview(menuItems)
        self.addSubview(subMenuItems)
        
        menuItems.frame = CGRect(x: 0, y: 40, width: safeFrame.width, height: 44)
        subMenuItems.frame = CGRect(x: 0, y: 80, width: safeFrame.width, height: 400)
        
        customerMenuButton.addTarget(self, action: #selector(showCustomerMenu), for: .touchUpInside)
        insuranceMenuButton.addTarget(self, action: #selector(showInsuranceMenu), for: .touchUpInside)
        CloseButton.addTarget(self, action: #selector(closeMenu), for: .touchUpInside)
    }
    
    @objc func showCustomerMenu() {
        self.outputView.subviews.forEach { $0.removeFromSuperview() }
        self.subMenuItems.subviews.forEach { $0.removeFromSuperview() }
        let Customersubview = self.customerView.customerMenu()
        self.subMenuItems.addSubview(Customersubview)
    }
    
    @objc func showInsuranceMenu() {
        self.outputView.subviews.forEach { $0.removeFromSuperview() }
        self.subMenuItems.subviews.forEach { $0.removeFromSuperview() }
        let Insurancesubview = self.insuranceView.insuranceMenu()
        self.subMenuItems.addSubview(Insurancesubview)
    }

    @objc func closeMenu() {
    self.outputView.subviews.forEach { $0.removeFromSuperview() }
        self.subMenuItems.subviews.forEach { $0.removeFromSuperview() }
    }
}
