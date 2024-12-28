//
//  ClaimTableViewController.swift
//  Insurance Policy System application
//
//  Created by jahnavi patel on 10/29/24.
//

import UIKit

class ClaimTableViewController: UITableViewController {
    
    var mainVC: ViewController?
    let searchController = UISearchController(searchResultsController: nil)
    
    var filteredResults: [Claim_table] = []
    
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
            return
        }
        
        if searchController.isActive {
            searchController.isActive = false
        }
        filteredResults = mainVC.claim_table
        tableView.reloadData()
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(
        _ tableView: UITableView, numberOfRowsInSection section: Int
    ) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredResults.count
    }
    
    override func tableView(
        _ tableView: UITableView, cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = UITableViewCell(
            style: .subtitle, reuseIdentifier: "ClaimCell")
        // Configure the cell...
        let claim = filteredResults[indexPath.row]
        
        let insurance_id = claim.policy_id
        let insurance = mainVC?.insurance_table.first(where: { $0.id == insurance_id })
        
        let customer = mainVC?.customer_table.first(where: { $0.id == insurance?.customer_id })
        
        
        cell.textLabel?.text = "Claim ID: \(claim.id) Status: \(claim.status ?? "pending")"
        cell.detailTextLabel?.text =
        "Policy ID: \(insurance?.id ?? 0)  Customer Name: \(customer?.name ?? "")"
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(
        _ tableView: UITableView, canEditRowAt indexPath: IndexPath
    ) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return !searchController.isActive
    }
    
    // Override to support editing the table view.
    override func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle == .delete  , let mainVC = mainVC {
            // Delete the row from the data source
            //            approved claim cannot be deleted
            let claim = mainVC.claim_table[indexPath.row]
            if claim.status == "Approved" {
                showAlert(title: "Error", message: "Claim cannot be deleted")
                return
            }
            mainVC.managedContext.delete(claim)
            do{
                try mainVC.managedContext.save()
            } catch {
                print("Failed to save data: \(error)")
            }
            
            mainVC.claim_table.remove(at: indexPath.row)
            filteredResults.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func tableView(
        _ tableView: UITableView, didSelectRowAt indexPath: IndexPath
    ) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(
            withIdentifier: "UpdateClaimVC") as? UpdateClaimViewController
        {
            vc.mainVC = mainVC
            vc.indexPath = indexPath
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func addTapped(_ sender: UIBarButtonItem) {
        let addClaimVC =
        storyboard?.instantiateViewController(withIdentifier: "AddClaimVC")
        as! AddClaimViewController
        addClaimVC.mainVC = mainVC
        navigationController?.pushViewController(addClaimVC, animated: true)
    }
    
    func showAlert(
        title: String, message: String, completion: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(
            title: title, message: message, preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(
                title: "OK", style: .default,
                handler: { _ in
                    completion?()
                }))
        present(alert, animated: true, completion: nil)
    }
    
}

extension ClaimTableViewController: UISearchResultsUpdating, UISearchBarDelegate
{
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, let mainVC = mainVC else { return }
        
        if text.isEmpty {
            filteredResults = self.mainVC?.claim_table ?? []
            
        } else {
            filteredResults = mainVC.claim_table.filter { claim in
                let insurance_id = claim.policy_id
                let insurance = mainVC.insurance_table.first(where: { $0.id == insurance_id })
                let customer = mainVC.customer_table.first(where: { $0.id == insurance?.customer_id })
                return String(claim.id).lowercased().contains(text.lowercased()) ||
                String(insurance?.id ?? 0).lowercased().contains(text.lowercased()) ||
                customer?.name?.lowercased().contains(text.lowercased()) ?? false

//                ||
//                customer?.name?.lowercased().contains(text.lowercased()) ?? false

            }
            if filteredResults.isEmpty {
                showAlert(title: "No results", message: "No claims found")

            }
        }
        tableView.reloadData()
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            self.filteredResults = self.mainVC?.claim_table ?? []
            self.tableView.reloadData()
        }
    }
}
