//
//  PaymentTableViewController.swift
//  Insurance Policy System application
//
//  Created by jahnavi patel on 10/29/24.
//

import UIKit

class PaymentTableViewController: UITableViewController {

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
        print("Number of payments: \(mainVC.payments.count)")

        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let count = mainVC?.payments.count ?? 0
        if count == 0 {
            if self.presentedViewController == nil {
                let alert = UIAlertController(title: "No Payments", message: "Please add a payment", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        }
        return count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "PaymentCell")
        // Configure the cell...
        let payment = mainVC?.payments[indexPath.row]


        cell.textLabel?.text = "Payment ID: \(payment?.id ?? 0)"
        cell.detailTextLabel?.text = "Policy ID: \(payment?.policy_id ?? 0) Amount: \(payment?.payment_amount ?? 0) status: \(payment?.status ?? "")"

        return cell
    }



    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }



    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete , let mainVC = mainVC {
            // Delete the row from the data source
//            processed payment cannot be deleted
            let payment = mainVC.payments[indexPath.row]
            if payment.status == "Processed" {
                let alert = UIAlertController(title: "Error", message: "Processed payment cannot be deleted", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
                return
            }
            let insurance = mainVC.insurance.first(where: { $0.id == payment.id })
            insurance?.removePayment(payment: payment)
            mainVC.payments.remove(at: indexPath.row)
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
