//
//  CategoryViewController.swift
//  todoey
//
//  Created by Apple on 10/13/1396 AP.
//  Copyright © 1396 AP Amin Torabi. All rights reserved.
//

import UIKit
import RealmSwift
class CategoryViewController: UITableViewController {
    var categoryArray: Results<Category>?
    let realm = try! Realm()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
    }
   
    
    
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return categoryArray?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "secCell", for: indexPath)
       
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "no categories added yet"
        return cell
    }
    
    
    /***************************************************/
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexpath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexpath.row]
        }
    }
    
    
    //    MARK: - Add New Category

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        var alert = UIAlertController(title: "Add Category", message: "Add a new Category", preferredStyle: .alert)
        var action = UIAlertAction(title: "Add Categories", style: .default) { (action) in
            
            let newCategory = Category()
            
            newCategory.name = textField.text!
            
        
            
            self.save(category: newCategory)
            
            self.tableView.reloadData()
            
            
            
        }
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new Category"
            textField = alertTextField
        }
        present(alert, animated: true, completion: nil)
        tableView.reloadData()
 //    MARK : - Data Manipulation Methods
    }
    func save(category:Category){
        do{
            try realm.write {
              
                realm.add(category)
            }
        }catch{
            print("error save category \(error)")
        }
        
    }
    func loadCategories () {
       categoryArray = realm.objects(Category.self)

    }
    
   
    
}
