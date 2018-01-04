//
//  CategoryViewController.swift
//  todoey
//
//  Created by Apple on 10/13/1396 AP.
//  Copyright © 1396 AP Amin Torabi. All rights reserved.
//

import UIKit
import CoreData
class CategoryViewController: UITableViewController {
    var categoryArray = [Category]()
    let contex = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext


    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
    }
   
    
    
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return categoryArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "secCell", for: indexPath)
        let category = categoryArray[indexPath.row]
        cell.textLabel?.text = category.name
        return cell
    }
    
    
    /***************************************************/
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexpath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexpath.row]
        }
    }
    
    
    //    MARK: - Add New Category

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        var alert = UIAlertController(title: "Add Category", message: "Add a new Category", preferredStyle: .alert)
        var action = UIAlertAction(title: "Add Categories", style: .default) { (action) in
            let newCategory = Category(context: self.contex)
            newCategory.name = textField.text!
            self.categoryArray.append(newCategory)
            self.saveCategory()
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
    func saveCategory(){
        do{
        try contex.save()
        }catch{
            print("error save category \(error)")
        }
        
    }
    func loadCategories () {
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        do{
            categoryArray = try contex.fetch(request)
        }catch{
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
    
   
    
}
