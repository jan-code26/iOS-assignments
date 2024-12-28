//
//  CustomerTableViewController.swift
//  Insurance Policy System application
//
//  Created by jahnavi patel on 10/28/24.
//

import UIKit

class CustomerTableViewController: UITableViewController {
    
    var mainVC: ViewController?
    let searchController = UISearchController(searchResultsController: nil)
    let imageCache = NSCache<NSString, UIImage>()
    
    var filteredResults: [Customer_table] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addTapped(_:))
        )
        self.navigationItem.rightBarButtonItem = addButton
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Type to search by name"
        navigationItem.searchController = searchController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let mainVC = self.mainVC else {
            return
        }
        
        if(searchController.isActive) {
            searchController.isActive = false
        }
        filteredResults = mainVC.customer_table
        
        
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredResults.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "CustomerCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) ?? UITableViewCell(style: .subtitle, reuseIdentifier: identifier)
        
        let customer = filteredResults[indexPath.row]
        cell.textLabel?.text = customer.name
        cell.detailTextLabel?.text = "Age: \(customer.age), Email: \(customer.email ?? "email")"
        
        let targetSize = CGSize(width: 40, height: 40)
        cell.imageView?.image = UIImage(systemName: "person.circle")?.scaleImage(toSize: targetSize) // Set default image first
        
        if let avatarURL = customer.avatarURL, let url = URL(string: avatarURL) {
            if let cachedImage = imageCache.object(forKey: avatarURL as NSString) {
                cell.imageView?.image = cachedImage.scaleImage(toSize: targetSize)
            } else {
                loadImageAsync(from: url) { [weak self, weak tableView] image in
                    guard let self = self, let tableView = tableView else { return }
                    if let image = image {
                        self.imageCache.setObject(image, forKey: avatarURL as NSString)
                        if let updatedCell = tableView.cellForRow(at: indexPath) {
                            updatedCell.imageView?.image = image.scaleImage(toSize: targetSize)
                            updatedCell.setNeedsLayout() // Ensure layout is updated
                        }
                    }
                }
            }
        } else if let imageData = customer.avatarImageData {
            cell.imageView?.image = UIImage(data: imageData)?.scaleImage(toSize: targetSize)
            cell.setNeedsLayout()
        }
        
        return cell
    }
    
    func loadImageAsync(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("Failed to load image data: \(String(describing: error))")
                DispatchQueue.main.async { completion(nil) }
                return
            }
            DispatchQueue.main.async {
                completion(UIImage(data: data))
            }
        }.resume()
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return !searchController.isActive
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete, let mainVC = mainVC {
            // Delete the row from the data source
            //     customer with existing insurance cannot be deleted
            let customer = mainVC.customer_table[indexPath.row]
            let insurance = mainVC.insurance_table.first(where: { $0.customer_id == customer.id })
            if insurance != nil {
                let alert = UIAlertController(
                    title: "Cannot delete customer",
                    message: "Customer has existing insurance",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
                return
            }

                
            // Delete the customer from Core Data
            mainVC.managedContext.delete(customer)
            
            // Save the context
            do {
                try mainVC.managedContext.save()
            } catch {
                print("Failed to save context after deletion: \(error)")
            }
            mainVC.customer_table.remove(at: indexPath.row)
            filteredResults.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(
            withIdentifier: "UpdateCustomerVC") as? UpdateCustomerViewController {
            vc.mainVC = mainVC
            vc.indexPath = indexPath
            self.navigationController?.pushViewController(vc, animated: true)
        }
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
    
    //Mark custom methods
    
    @objc func addTapped(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(
            withIdentifier: "AddCustomerVC") as? AddCustomerViewController {
            vc.mainVC = mainVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
   
}


extension CustomerTableViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            return
        }
        guard let mainVC = mainVC else {
            return
        }
        if searchText.isEmpty {
            filteredResults = mainVC.customer_table
        } else {
            filteredResults = mainVC.customer_table.filter { customer in
                if let name = customer.name {
                    return name.lowercased().contains(searchText.lowercased())
                }
                
                return false
            }

        }
        tableView.reloadData()
    }
    
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            self.filteredResults = self.mainVC?.customer_table ?? []
            self.tableView.reloadData()
        }
    }
}
