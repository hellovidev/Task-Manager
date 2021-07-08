//
//  ViewController.swift
//  Task Manager
//
//  Created by Sergei Romanchuk on 07.07.2021.
//

import UIKit

// MARK: - UITableViewController
class TodoListViewController: UITableViewController {
    
    // MARK: - Private Items
    private var itemArray = [Item]()
    
    private let defaults = UserDefaults()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first)
        //        if let array = self.defaults.array(forKey: "TodoList") as? [Item] {
        //            self.itemArray = array
        //        }
        
        self.loadItems()
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
        
        cell.accessoryType = item.isComplete! ? .checkmark : .none
        
        return cell
    }
    
    // MARK: - UITableViewDelegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].isComplete = !itemArray[indexPath.row].isComplete!
        
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
            var newItem = Item()
            
            if let text = textField.text {
                newItem.title = text
                self.itemArray.append(newItem)
                self.saveItems()
                //self.defaults.setValue(self.itemArray, forKey: "TodoList")
            }
            self.tableView.reloadData()
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
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.dataFilePath!)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            
            do {
                self.itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
