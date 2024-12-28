//
//  PaymentTableViewController.swift
//  Insurance Policy System application
//
//  Created by jahnavi patel on 10/29/24.
//

import UIKit

class PaymentTableViewController: UITableViewController {
    
    var mainVC: ViewController?
    let searchController = UISearchController(searchResultsController: nil)
    
    var filteredResults: [Payment_table] = []
    
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
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Type to search"
        navigationItem.searchController = searchController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let mainVC = self.mainVC else {
            print("mainVC is nil")
            return }
        print("mainVC is set")
        
        if(searchController.isActive) {
            searchController.isActive = false
        }
        filteredResults = mainVC.payment_table
        
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredResults.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "PaymentCell")
        // Configure the cell...
        let payment = filteredResults[indexPath.row]
        let insurance = payment.policy_id
        
        let customer = insurance?.customer_id
        
        
        cell.textLabel?.text = "Payment Id: \(String(payment.id))"
        //                cell.detailTextLabel?.text = "Policy ID: \(payment?.policy_id ?? 0) Amount: \(payment?.payment_amount ?? 0) status: \(payment?.status ?? "")"
        cell.detailTextLabel?.text = "Status: \(payment.status ?? "pending") policyID: \(payment.policy_id?.id ?? 0) C.Name: \(customer?.name ?? "")"
        return cell
    }
    
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return !searchController.isActive
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete , let mainVC = mainVC {
            // Delete the row from the data source
            //            processed payment cannot be deleted
            let payment = mainVC.payment_table[indexPath.row]
            if payment.status == "Processed" {
                let alert = UIAlertController(title: "Error", message: "Processed payment cannot be deleted", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
                return
            }
            mainVC.managedContext.delete(payment)
            do{
                try mainVC.managedContext.save()
            } catch {
                print("Failed to save data: \(error)")
            }
            mainVC.payment_table.remove(at: indexPath.row)
            filteredResults.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(
            withIdentifier: "UpdatePaymentVC") as? UpdatePaymentViewController {
            vc.mainVC = mainVC
            vc.indexPath = indexPath
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func addTapped(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(
            withIdentifier: "AddPaymentVC") as? AddPaymentViewController {
            vc.mainVC = mainVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}

extension PaymentTableViewController: UISearchResultsUpdating , UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let searchText = searchBar.text ?? ""
        if searchText.isEmpty {
            filteredResults = mainVC?.payment_table ?? []
        } else {
            filteredResults = mainVC?.payment_table.filter { payment in
                let insurance = payment.policy_id
                let customer = insurance?.customer_id
                return String(payment.id).lowercased().contains(searchText.lowercased()) ||
                String(insurance?.id ?? 0).lowercased().contains(searchText.lowercased()) ||
                customer?.name?.lowercased().contains(searchText.lowercased()) ?? false
                
            } ?? []
        }
        
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filteredResults = mainVC?.payment_table ?? []
        tableView.reloadData()
    }
}
