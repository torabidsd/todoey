//
//  ViewController.swift
//  todoey
//
//  Created by Apple on 12/27/17.
//  Copyright © 2017 Amin Torabi. All rights reserved.
//

import UIKit
import CoreData
class TodoListViewController: UITableViewController {
    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    let contex = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        override func viewDidLoad() {
        super.viewDidLoad()
       
            print( FileManager.default.urls(for: .documentDirectory, in: .userDomainMask ))
        
        
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for:indexPath)
       let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
       
        cell.accessoryType = item.done == true ? .checkmark : .none
        
      
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("You tapped cell ( \(itemArray[indexPath.row])).")

//        contex.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
//
          itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
       
       tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
//    MARK - add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style:.default) { (action) in
        
            
            let newItem = Item(context: self.contex)
            
            newItem.title = textField.text!
           newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
            self.saveItems()
            
            self.tableView.reloadData()
        }
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
             textField = alertTextField
        }
present(alert, animated: true, completion: nil)
    }
    func saveItems() {
        do {
           try contex.save()
        }catch{
            print("error saving context \(error)")
        }
        
    }
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest() , predicate:NSPredicate? = nil) {
       
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
        }else{
            request.predicate = categoryPredicate
        }
        
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate ,predicate!])
//
//        request.predicate = compoundPredicate
        
        do{
           itemArray = try contex.fetch(request)
        }catch{
            print("Error fetching data from context \(error)")
        }
    }
   
}
//MARK: - searchbar method
extension TodoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
       
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request,predicate: predicate)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            DispatchQueue.main.async {
               
                searchBar.resignFirstResponder()
            }
            
        }
    }
}






