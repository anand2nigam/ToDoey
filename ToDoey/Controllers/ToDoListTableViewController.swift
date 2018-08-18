//
//  ToDoListTableViewController.swift
//  ToDoey
//
//  Created by Anand Nigam on 09/08/18.
//  Copyright © 2018 Anand Nigam. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListTableViewController: SwipeTableViewController {

    var itemArray: Results<Item>?
    
    let realm = try! Realm()
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = (selectedCategory?.name)! + " Items"

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
        return itemArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Using a reusable cell to display the cells in the table view
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let items = itemArray?[indexPath.row] {
            cell.textLabel?.text = items.title
            
            // To put the checkmark and remove it accordingly
            cell.accessoryType = items.done == true ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No cells added"
        }
      
        
        return cell
    }
    
    
    // MARK:- Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
        if let item = itemArray?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error in updating data \(error)")
            }
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
            
            // what will happen when the user clicks the add item button
            
            print("Success")
            print(textField.text!)
        
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                          let newItem = Item()
                        newItem.title = textField.text ?? "New Item"
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error in saving data  \(error)")
                }
            }
            
          self.tableView.reloadData()
            
            
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
    
//    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
//        return .delete
//    }
//    
//    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//
//            let alert = UIAlertController(title: "DELETE ???", message: "Are you sure you want to delete?", preferredStyle: .alert)
//
//            let deleteAction = UIAlertAction(title: "Delete", style: .default) { (deleteAlertAction) in
//                if let item = self.itemArray?[indexPath.row] {
//                    do {
//                        try self.realm.write {
//                            self.realm.delete(item)
//                            self.tableView.reloadData()
//                        }
//                    } catch {
//                        print("Error in saving data after deletion \(error)")
//                    }
//                }
//            }
//
//            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//
//            alert.addAction(deleteAction)
//            alert.addAction(cancelAction)
//
//            present(alert, animated: true, completion: nil)
//
//
//        }
//    }
    
    
    override func updateModel(at indexPath: IndexPath) {
        if let itemForDeletion = self.itemArray?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(itemForDeletion)
                }
            } catch {
                print("Error in deleting data from the database : \(error)")
            }
        }
    }
    
    // MARK:- Data Manipulation Method
    
    
    // method with a default value which can be called with the parameter or without the parameter
    func loadItems() {

        itemArray = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)


        tableView.reloadData()
    }


}




// MARK: Search bar Methods

extension ToDoListTableViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        itemArray = itemArray?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)

        tableView.reloadData()

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
