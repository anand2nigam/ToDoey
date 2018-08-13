//
//  CategoryTableViewController.swift
//  ToDoey
//
//  Created by Anand Nigam on 13/08/18.
//  Copyright © 2018 Anand Nigam. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {

    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()

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
    

    
    
    
    // MARK:- Add new Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Categories", message: "", preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Add Category", style: .default) { (alertAction) in
          
            let newCategory = Category(context: self.context)
            
            newCategory.name = textField.text
            
            self.categoryArray.append(newCategory)
            
            self.saveCategories()
            
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
    
    // MARK:- Data Manipulation Methods
    
    func saveCategories() {
        do {
        try context.save()
        } catch {
            print("Error Saving Categories:-  \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
       
        do {
           categoryArray = try context.fetch(request)
        } catch {
            print("Error in loading data from the database:  \(error)")
        }
        tableView.reloadData()
    }
    
}
