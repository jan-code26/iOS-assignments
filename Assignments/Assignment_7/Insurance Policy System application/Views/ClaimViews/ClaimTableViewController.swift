//
//  ClaimTableViewController.swift
//  Insurance Policy System application
//
//  Created by jahnavi patel on 10/29/24.
//

import UIKit

class ClaimTableViewController: UITableViewController {
    
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
        print("Number of claims: \(mainVC.claims.count)")
        
        tableView.reloadData()
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let count = mainVC?.claims.count ?? 0
        if count == 0 {
            if self.presentedViewController == nil {
                let alert = UIAlertController(title: "No Claims", message: "Please add a claim", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        }
        return count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "ClaimCell")
        // Configure the cell...
        let claim = mainVC?.claims[indexPath.row]
        
        cell.textLabel?.text = "Claim ID: \(claim?.id ?? 0)"
        cell.detailTextLabel?.text = "policy ID: \(claim?.policy_id ?? 0)  Claim Amount: \(claim?.claim_amount ?? 0) Status: \(claim?.status ?? "")"
        return cell
    }
    
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            //            approved claim cannot be deleted
            let claim = mainVC?.claims[indexPath.row]
            if claim?.status == "Approved" {
                showAlert(title: "Error", message: "Claim cannot be deleted")
                return
            }
            let insurance = mainVC?.insurance.first(where: { $0.id == claim?.policy_id })
            guard let insurance = insurance else { return }
            insurance.removeClaim(claim: claim!)
            mainVC?.claims.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let  storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "UpdateClaimVC") as? UpdateClaimViewController {
            vc.mainVC = mainVC
            vc.indexPath = indexPath
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func addTapped(_ sender: UIBarButtonItem) {
        let addClaimVC = storyboard?.instantiateViewController(withIdentifier: "AddClaimVC") as! AddClaimViewController
        addClaimVC.mainVC = mainVC
        navigationController?.pushViewController(addClaimVC, animated: true)
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
    
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    
}
