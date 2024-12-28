//
//  InsuranceTableViewController.swift
//  Insurance Policy System application
//
//  Created by jahnavi patel on 10/29/24.
//

import UIKit

class InsuranceTableViewController: UITableViewController {
    
    var mainVC: ViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addTapped(_:))
        )
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let mainVC = self.mainVC else {
            print("mainVC is nil")
            return }
        print("mainVC is set")
        print("Number of insurance: \(mainVC.insurance.count)")

        // Sort the insurance policies by end date
            mainVC.insurance.sort { $0.end_date < $1.end_date }

        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let count = mainVC?.insurance.count ?? 0
        if count == 0 {
            if self.presentedViewController == nil {
                let alert = UIAlertController(title: "No Insurance", message: "Please add an insurance", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        }
        return count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "insuranceCell")
        // Configure the cell...
        let insurance = mainVC?.insurance[indexPath.row]

//        get the customer  from the customer id
        let customer = mainVC?.customer.first(where: { $0.id == insurance?.customer_id })

        cell.textLabel?.text = "Policy Type: \(insurance?.policy_type ?? "")"
        cell.detailTextLabel?.text = "Customer: \(customer?.name ?? "") ; Premium Amount: \(insurance?.premium_amount ?? 0)"
        return cell
    }
    
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete,let mainVC = mainVC  {
            // Delete the row from the data source
            //active insurance cannot be deleted that is end date is greater than current date
            let insurance = mainVC.insurance[indexPath.row]
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy"
            let currentDate = Date()
            if insurance.end_date > currentDate {
                let alert = UIAlertController(title: "Active Insurance", message: "Insurance is active and cannot be deleted", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
                return
            }
            mainVC.insurance.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(
            withIdentifier: "UpdateInsuranceVC") as? UpdateInsuranceViewController {
            vc.mainVC = mainVC
            vc.indexPath = indexPath
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func addTapped(_ sender: UIBarButtonItem) {
        let addInsuranceVC = storyboard?.instantiateViewController(withIdentifier: "AddInsuranceVC") as! AddInsuranceViewController
        addInsuranceVC.mainVC = mainVC
        navigationController?.pushViewController(addInsuranceVC, animated: true)
    }
    
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
