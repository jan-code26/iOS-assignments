//
//  ViewController.swift
//  Insurance Policy System application
//
//  Created by jahnavi patel on 10/22/24.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var rotatingStackView: UIStackView!
    
    
    var customer_table =  [Customer_table]()
    var insurance_table = [Insurance_table]()
    var claim_table = [Claim_table]()
    var payment_table = [Payment_table]()
    
    var managedContext: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext ?? NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        return dateFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Main Menu"
        
        if !UserDefaults.standard.bool(forKey: "isDummyDataGenerated") {
            getDummyData()
            UserDefaults.standard.set(true, forKey: "isDummyDataGenerated")
        }
        loadAllData()
    }
    func getDummyData() {
    print("hello")
    guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
        return
    }

    APIUtils.getAllCustomerDetails(context: context) { customerDetails in
        self.customer_table = customerDetails
    }
    APIUtils.getAllInsuranceDetails(context: context) { insuranceDetails in
        self.insurance_table = insuranceDetails.filter { $0 != nil }
    }
    APIUtils.getAllClaimDetails(context: context) { claimDetails in
        self.claim_table = claimDetails.filter { $0 != nil }
    }
    APIUtils.getAllPaymentDetails(context: context) { paymentDetails in
        self.payment_table = paymentDetails.filter { $0 != nil }
    }

    do {
        try context.save()
    } catch {
        print("Error saving context: \(error)")
    }
}

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination
        if let vc = destinationVC as? CustomerTableViewController {
            vc.mainVC = self
        }
        if let vc = destinationVC as? InsuranceTableViewController {
            vc.mainVC = self
        }
        if let vc = destinationVC as? ClaimTableViewController {
            vc.mainVC = self
        }
        if let vc = destinationVC as? PaymentTableViewController {
            vc.mainVC = self
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        print("Orientation changed to: \(UIDevice.current.orientation)")
        if UIDevice.current.orientation.isLandscape {
            rotatingStackView.axis = .horizontal
        } else {
            rotatingStackView.axis = .vertical
        }
    }
    
    
    func loadAllData() {
        // Fetch Customer_table data
        let customerFetchRequest: NSFetchRequest<Customer_table> = Customer_table.fetchRequest()
        let customerSortDescriptor = NSSortDescriptor(key: "name", ascending: false)
        customerFetchRequest.sortDescriptors = [customerSortDescriptor]
        
        // Fetch Insurance_table data
        let insuranceFetchRequest: NSFetchRequest<Insurance_table> = Insurance_table.fetchRequest()
        let insuranceSortDescriptor = NSSortDescriptor(key: "policy_type", ascending: true)
        insuranceFetchRequest.sortDescriptors = [insuranceSortDescriptor]
        
        // Fetch Claim_table data
        let claimFetchRequest: NSFetchRequest<Claim_table> = Claim_table.fetchRequest()
        let claimSortDescriptor = NSSortDescriptor(key: "date_of_claim", ascending: false)
        claimFetchRequest.sortDescriptors = [claimSortDescriptor]
        
        // Fetch Payment_table data
        let paymentFetchRequest: NSFetchRequest<Payment_table> = Payment_table.fetchRequest()
        let paymentSortDescriptor = NSSortDescriptor(key: "payment_date", ascending: false)
        paymentFetchRequest.sortDescriptors = [paymentSortDescriptor]
        
        do {
            self.customer_table = try self.managedContext.fetch(customerFetchRequest)
            self.insurance_table = try self.managedContext.fetch(insuranceFetchRequest)
            self.claim_table = try self.managedContext.fetch(claimFetchRequest)
            self.payment_table = try self.managedContext.fetch(paymentFetchRequest)
        } catch {
            fatalError("Failed to fetch data: \(error)")
        }
    }
    
}

extension CodingUserInfoKey {
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}

extension UIImage {
    func scaleImage(toSize newSize: CGSize) -> UIImage? {
        var newImage: UIImage?
        let newRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height).integral
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        if let context = UIGraphicsGetCurrentContext(), let cgImage = self.cgImage {
            context.interpolationQuality = .high
            let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: newSize.height)
            context.concatenate(flipVertical)
            context.draw(cgImage, in: newRect)
            if let img = context.makeImage() {
                newImage = UIImage(cgImage: img)
            }
            UIGraphicsEndImageContext()
        }
        return newImage
    }
}
