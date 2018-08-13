//
//  ToDoListTableViewController.swift
//  ToDoey
//
//  Created by Anand Nigam on 09/08/18.
//  Copyright © 2018 Anand Nigam. All rights reserved.
//

import UIKit
import CoreData

class ToDoListTableViewController: UITableViewController {

    var itemArray = [ Item ] ()
    

    
     // to grab the viewContext of the app delegate class
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         //self.navigationItem.leftBarButtonItem = self.editButtonItem
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
        
         itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
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
            
            // what will happen when the user clicks the add item button
            
            print("Success")
            print(textField.text!)
        
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text ?? "New Item"
            newItem.done = false
            self.itemArray.append(newItem)
            
            self.saveItems()
            
        }
        
        // To cancel the alert without doing anything about it
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // Adding a textfield with the alert in order to add text for the new ToDoey item
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
    
    // MARK:-  Deletion of Data from Database and tableView
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(itemArray[indexPath.row])
            itemArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            saveItems()
        }
    }
    
    
    // MARK:- Data Manipulation Method
    
    func saveItems() {
        
        do {
           try context.save()
        } catch {
          print("Unable to save the context \(error)")
        }
        
        tableView.reloadData()
    }
    
    // method with a default value which can be called with the parameter or without the parameter
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error in loading data from persistent container \(error)")
        }
        
        tableView.reloadData()
    }


}




// MARK: Search bar Methods

extension ToDoListTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // Request to fetch the Item result from the database
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        // to specify how data should be fetched from the database
        // [cd] is used to make the search case and diacritic insensitive
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        // add query to the request
        request.predicate = predicate
        
        // to sort the data received from database on query accordingly
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        // to add this to the request
        request.sortDescriptors = [sortDescriptor]
        
        loadItems(with: request)
        
       
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                 // to remove the cursor from the focus and dismiss the keyboard
                searchBar.resignFirstResponder()
            }
        }
    }
    
    
}
