//
//  CategoryTableViewController.swift
//  ToDoey
//
//  Created by Anand Nigam on 13/08/18.
//  Copyright © 2018 Anand Nigam. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {
    
    let realm = try! Realm()

    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
   //     loadCategories()

    }

    // MARK:- TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
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
            destiinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    
    // MARK:- Add new Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Categories", message: "", preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Add Category", style: .default) { (alertAction) in
          
            let newCategory = Category()
            
            newCategory.name = textField.text!
            
            self.categoryArray.append(newCategory)
            
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
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            
//            // To present an alert before deleting the row from the database and the tableview
//            let alert = UIAlertController(title: "DELETE???", message: "Are you sure you want to delete", preferredStyle: .alert)
//            
//            let deleteAction = UIAlertAction(title: "Delete", style: .default) { (deleteAlertAction) in
//                self.context.delete(self.categoryArray[indexPath.row])
//                self.categoryArray.remove(at: indexPath.row)
//                self.tableView.deleteRows(at: [indexPath], with: .automatic)
//                self.saveCategories()
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
//    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
//
//        do {
//           categoryArray = try context.fetch(request)
//        } catch {
//            print("Error in loading data from the database:  \(error)")
//        }
//        tableView.reloadData()
//    }
//
}
