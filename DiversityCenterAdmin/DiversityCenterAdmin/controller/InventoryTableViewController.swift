//
//  InventoryTableViewController.swift
//  DiversityCenterAdmin
//
//  Created by Arrido Arfiadi on 9/1/18.
//  Copyright © 2018 Arrido Arfiadi. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class InventoryTableViewController: UITableViewController {
    var itemName: [String] = []
    var count: [String]  = []
    var ref: DatabaseReference = Database.database().reference()
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemName.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            
        cell?.textLabel?.text = itemName[indexPath.row]
        cell?.detailTextLabel?.text = "\(count[indexPath.row])"
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = ref.child("DCPantry").child(itemName[indexPath.row])
        let alert = UIAlertController(title: "Edit \(itemName[indexPath.row])", message: "Insert updated value", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (alertAction) in
            item.removeValue()
            self.getData()
        }))
        alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { (alertAction) in
            let valueField = alert.textFields![0]
            if valueField.text != ""{
                item.setValue(valueField.text)
                self.getData()
            }
            
        }))
        self.present(alert,animated: true,completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func getData(){
        itemName = []
        count = []
        //retrieve from db
        SVProgressHUD.show()
        let pantryDB = ref.child("DCPantry")
        pantryDB.observe(.childAdded) { (snapshot) in
            let name = snapshot.key
            let number = snapshot.value as! String
            self.itemName.append(name)
            self.count.append(number)
            self.tableView.reloadData()
            SVProgressHUD.dismiss()
        }
    }
    @IBAction func addClicked(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "goToInsert", sender: self)
    }
}
