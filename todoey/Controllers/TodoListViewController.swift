//
//  ViewController.swift
//  todoey
//
//  Created by Apple on 12/27/17.
//  Copyright © 2017 Amin Torabi. All rights reserved.
//

import UIKit
import RealmSwift
class TodoListViewController: UITableViewController {
    var todoItems : Results<Item>?
    let realm = try! Realm()
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    
        override func viewDidLoad() {
        super.viewDidLoad()
       
            print( FileManager.default.urls(for: .documentDirectory, in: .userDomainMask ))
        
        
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     return todoItems?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for:indexPath)
    
        if let item = todoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done == true ? .checkmark : .none
        }else{
            cell.textLabel?.text = "no Items added"
        }
       
        
        
      
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row]{
            do{
            try realm.write {
                item.done = !item.done
            }
            }catch{
                print("Error saving don status.\(error)")
            }
        }
//        print("You tapped cell ( \(itemArray[indexPath.row])).")

//        contex.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
//
//          todoItems[indexPath.row].done = !todoItems[indexPath.row].done
//
//        saveItems()
//
       
       tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
//    MARK - add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style:.default) { (action) in
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.dateCreated = Date()
                    currentCategory.items.append(newItem)
                }
                }catch{
                    print("error savingnew items \(error)")
                }
            }
            
            
            
            self.tableView.reloadData()
        }
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
             textField = alertTextField
        }
present(alert, animated: true, completion: nil)
    }
   
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
//
   tableView.reloadData()
}
}
//MARK: - searchbar method
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
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






