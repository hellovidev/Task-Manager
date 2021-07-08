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
    private var itemArray = ["Order Vortex Keyboard",
                             "Check Apple Mouse",
                             "Buy MacBook",
                             "Buy MacBook",
                             "Buy MacBook",
                             "Buy MacBook",
                             "Buy MacBook",
                             "Buy MacBook",
                             "Buy MacBook",
                             "Buy MacBook",
                             "Buy MacBook",
                             "Buy MacBook",
                             "Buy MacBook",
                             "Buy MacBook"]

    private let defaults = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let array = self.defaults.array(forKey: "TodoList") as? [String] {
            self.itemArray = array
        }
    }

    // MARK: - UITableViewDataSource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "TaskCell")
        //let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }

    // MARK: - UITableViewDelegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Append Item To List

    @IBAction func newTaskAction(_ sender: UIBarButtonItem) {
        var textField = UITextField()

        let alert = UIAlertController(title: "New task creation", message: "Input task title", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add new item", style: .default, handler: { _ in
            if let text = textField.text {
                self.itemArray.append(text)
                self.defaults.setValue(self.itemArray, forKey: "TodoList")
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

}
