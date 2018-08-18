//
//  CategoryTableViewController.swift
//  ToDoey
//
//  Created by Anand Nigam on 13/08/18.
//  Copyright © 2018 Anand Nigam. All rights reserved.
//

import UIKit
import RealmSwift


class CategoryTableViewController: SwipeTableViewController {
    
    let realm = try! Realm()

    var categoryArray: Results<Category>?
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()

    }

    // MARK:- TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories added yet"
        cell.accessoryType = .disclosureIndicator
        
        
        
        return cell
    }
    
    // MARK:- TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destiinationVC = segue.destination as! ToDoListTableViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destiinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    
    // MARK:- Add new Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Categories", message: "", preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Add Category", style: .default) { (alertAction) in
          
            let newCategory = Category()
            
            newCategory.name = textField.text!
            
            
            
            self.save(category: newCategory)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add New ToDo Categories"
            textField = alertTextField
            
        }
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
        tableView.reloadData()
        
    }
    
    // MARK:- Deletion from the Database and the TableView
    
//    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
//        return .delete
//    }
//
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//
//            // To present an alert before deleting the row from the database and the tableview
//            let alert = UIAlertController(title: "DELETE???", message: "Are you sure you want to delete", preferredStyle: .alert)
//
//            let deleteAction = UIAlertAction(title: "Delete", style: .default) { (deleteAlertAction) in
//                if let category = self.categoryArray?[indexPath.row] {
//                    do {
//                        try self.realm.write {
//                            self.realm.delete(category)
//                            tableView.reloadData()
//                        }
//                    } catch {
//                        print("Error saving data after deletion  \(error)")
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
//        }
//    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categoryArray?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error Deleting category:- \(error)")
            }
        }
    }
    
    // MARK:- Data Manipulation Methods
    
    // function to save the data into the database
    func save(category : Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error Saving Categories:-  \(error)")
        }
        tableView.reloadData()
    }
    
    // function to load the data from the database and then reflecting in the tableView
    func loadCategories() {

        categoryArray = realm.objects(Category.self)
        
        
        tableView.reloadData()
    }

}

