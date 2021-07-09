//
//  ViewController.swift
//  Task Manager
//
//  Created by Sergei Romanchuk on 07.07.2021.
//

import UIKit
import CoreData

// MARK: - UITableViewController
class TodoListViewController: UITableViewController {
    
    // MARK: - Private Items
    private var itemArray = [ItemEntity]()
    
    private let defaults = UserDefaults()
    
    private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext

    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first)
        //        if let array = self.defaults.array(forKey: "TodoList") as? [Item] {
        //            self.itemArray = array
        //        }
        fetchCoreData()
    }
    
    // MARK: - UITableViewDataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell(style: .default, reuseIdentifier: "TaskCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        //        item.isComplete! ? (cell.accessoryType = .checkmark) : (cell.accessoryType = .none)
        
        cell.accessoryType = item.complete ? .checkmark : .none
        
        return cell
    }
    
    // MARK: - UITableViewDelegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        context?.delete(itemArray[indexPath.row])
        itemArray.remove(at: indexPath.row)
        //itemArray[indexPath.row].complete = !itemArray[indexPath.row].complete
        
        //        if let isComplete = itemArray[indexPath.row].isComplete {
        //            isComplete ? (itemArray[indexPath.row].isComplete = false) : (itemArray[indexPath.row].isComplete = true)
        //        }
        
        //        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
        //            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        //        } else {
        //            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        //        }
        saveItems()
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Append Item To List
    
    @IBAction func newTaskAction(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "New task creation", message: "Input task title", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add new item", style: .default, handler: { _ in
                        
            let newItem = ItemEntity(context: self.context!)
            
            if let text = textField.text {
                newItem.title = text
                self.itemArray.append(newItem)
                self.saveItems()
                //self.defaults.setValue(self.itemArray, forKey: "TodoList")
            }
            
        })
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item..."
            textField = alertTextField
        }
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Model Manipulation Private Methods
    
    private func saveItems() {
        //let encoder = PropertyListEncoder()
        
        do {
            try self.context?.save()
            //let data = try encoder.encode(self.itemArray)
            //try data.write(to: self.dataFilePath!)
        } catch {
            print(error.localizedDescription)
        }
        
        self.tableView.reloadData()
    }
    
    func fetchCoreData(for request: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()) {
        do {
            if let safeContext = self.context {
                self.itemArray = try safeContext.fetch(request)
            }
        } catch {
            print("Fetch request Core Data error: \(error.localizedDescription)")
        }
    }
    
//    private func loadItems() {
//        if let data = try? Data(contentsOf: dataFilePath!) {
//            let decoder = PropertyListDecoder()
//
//            do {
//                self.itemArray = try decoder.decode([Item].self, from: data)
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
//    }
}

// MARK: - UISearchBarDelegate
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        // Query Language
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.predicate = predicate
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        request.sortDescriptors = [sortDescriptor]
        
        fetchCoreData(for: request)
        
        self.tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            fetchCoreData()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        } else {
            let request: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
            // Query Language
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchText)
            
            request.predicate = predicate
            
            let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
            
            request.sortDescriptors = [sortDescriptor]
            
            fetchCoreData(for: request)        }

        
        self.tableView.reloadData()
    }
}
