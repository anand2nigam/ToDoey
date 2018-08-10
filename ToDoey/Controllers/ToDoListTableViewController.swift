//
//  ToDoListTableViewController.swift
//  ToDoey
//
//  Created by Anand Nigam on 09/08/18.
//  Copyright © 2018 Anand Nigam. All rights reserved.
//

import UIKit

class ToDoListTableViewController: UITableViewController {

    var itemArray = [ Item ] ()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let items = defaults.array(forKey: "ToDoeyListArray") as? [Item] {
            itemArray = items
        }
        
        let newItem = Item()
        newItem.title = "Finish Novels"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "FInish Homework"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "FInish Lunch"
        itemArray.append(newItem3)
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Using a reusable cell to display the cells in the table view
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        // To put the checkmark and remove it accordingly
        cell.accessoryType = itemArray[indexPath.row].done == true ? .checkmark : .none
        
        return cell
    }
    
    
    // MARK:- Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        print(itemArray[indexPath.row])
        
        if itemArray[indexPath.row].done == true {
            itemArray[indexPath.row].done = false
        }
        else {
            itemArray[indexPath.row].done = true
        }
        
        tableView.reloadData()
        
        // To deselect the row after its selection
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK:- Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        // To present an alert to the user
        let alert = UIAlertController(title: "Add New ToDoey Item", message: "", preferredStyle: .alert)
        
        // To do something with the alert (adding a button in order to perform the task for which the alert is being presented)
        let action = UIAlertAction(title: "Add Item", style: .default) { (alertAction) in
            print("Success")
            print(textField.text!)
            
            let newItem = Item()
            newItem.title = textField.text ?? "New Item"
            self.itemArray.append(newItem)
            
            self.defaults.set(self.itemArray, forKey: "ToDoeyListArray")
            
            self.tableView.reloadData()
        }
        
        // To cancel the alert without doing anything about it
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // Adding a textfield in order to add text for the new ToDoey item
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New ToDoey Item"
            textField = alertTextField
        }
        
        // Adding actions to the alert
        alert.addAction(action)
        alert.addAction(cancelAction)
        
        // Presenting alert to the user
        present(alert, animated: true, completion: nil)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
