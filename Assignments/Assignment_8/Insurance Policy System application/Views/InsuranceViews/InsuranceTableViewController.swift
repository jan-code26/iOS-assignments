//
//  InsuranceTableViewController.swift
//  Insurance Policy System application
//
//  Created by jahnavi patel on 10/29/24.
//

import UIKit

class InsuranceTableViewController: UITableViewController {
    
    var mainVC: ViewController?
    let searchController = UISearchController(searchResultsController: nil)
    
    var filteredResults: [Insurance_table] = []
    
    
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
        filteredResults = mainVC.insurance_table
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
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "insuranceCell")
        // Configure the cell...
        let insurance = filteredResults[indexPath.row]
        guard mainVC != nil else {
            print("mainVC is nil")
            return cell
        }
        let customer = insurance.customer_id
        
        cell.textLabel?.text = "ID: \(insurance.id) Policy Type: \(insurance.policy_type ?? "Life")"
        cell.detailTextLabel?.text = "Customer: \(customer?.name ?? "Unknown") Premium: \(insurance.premium_amount)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return !searchController.isActive
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete,let mainVC = mainVC  {
            // Delete the row from the data source
            //active insurance cannot be deleted that is end date is greater than current date
            let insurance = mainVC.insurance_table[indexPath.row]
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy"
            let currentDate = Date()
            if insurance.end_date! > currentDate {
                let alert = UIAlertController(title: "Active Insurance", message: "Insurance is active and cannot be deleted", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
                return
            }
            //            delete related claims and payments
            
            let claims = insurance.claims?.allObjects as! [Claim_table]
            for claim in claims {
                mainVC.claim_table.remove(at: mainVC.claim_table.firstIndex(of: claim)!)
                mainVC.managedContext.delete(claim)
            }
            let payments = insurance.payments?.allObjects as! [Payment_table]
            for payment in payments {
                mainVC.payment_table.remove(at: mainVC.payment_table.firstIndex(of: payment)!)
                mainVC.managedContext.delete(payment)
            }
            mainVC.managedContext.delete(insurance)
            do{
                try mainVC.managedContext.save()
            } catch {
                print("Error saving context: \(error)")
            }
            mainVC.insurance_table.remove(at: indexPath.row)
            filteredResults.remove(at: indexPath.row)
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
    
}

extension InsuranceTableViewController: UISearchResultsUpdating , UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        if searchText.isEmpty {
            filteredResults = mainVC?.insurance_table ?? []
        } else {
            filteredResults = mainVC?.insurance_table.filter { insurance in
                let customer = insurance.customer_id
                return customer?.name!.lowercased().contains(searchText.lowercased()) ?? false ||
                String(insurance.id).lowercased().contains(searchText.lowercased())
            } ?? []
        }
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            self.filteredResults = self.mainVC?.insurance_table ?? []
            self.tableView.reloadData()
        }
    }
}
