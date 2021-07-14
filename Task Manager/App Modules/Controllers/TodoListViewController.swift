//
//  ViewController.swift
//  Task Manager
//
//  Created by Sergei Romanchuk on 07.07.2021.
//

import UIKit
import RealmSwift
import ChameleonFramework

// MARK: - UITableViewController
class TodoListViewController: SwipeTableViewController {
    
    // MARK: - Private Items
    private let realm = try! Realm()
    private var items: Results<ItemEntity>?
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedBoard: BoardEntity? {
        didSet {
            fetchItemsFromLocalDatabase()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let safeNavigationBar = self.navigationController?.navigationBar {
            if let currentBoardHexValue = selectedBoard?.hex {
                safeNavigationBar.backgroundColor = UIColor(hexString: currentBoardHexValue)
                safeNavigationBar.tintColor = ContrastColorOf(safeNavigationBar.backgroundColor!, returnFlat: true)
                self.searchBar.barTintColor = UIColor(hexString: currentBoardHexValue)
                self.searchBar.tintColor = ContrastColorOf(safeNavigationBar.backgroundColor!, returnFlat: true)
                safeNavigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(safeNavigationBar.backgroundColor!, returnFlat: true)]
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let safeBoardName = selectedBoard?.name {
            self.navigationItem.title = "Board \"\(safeBoardName)\""
        }
    }
    
    override func updateModel(at indexPath: IndexPath) {
        do {
            try self.realm.write {
                if let itemToDelete = self.items?[indexPath.row] {
                    self.realm.delete(itemToDelete)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - UITableViewDataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = items?[indexPath.row] {
            cell.backgroundColor = UIColor(hexString: self.selectedBoard?.hex ?? "#333333")?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(items!.count))
            cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
            cell.textLabel?.text = item.title
            cell.accessoryType = item.isComplete! ? .checkmark : .none
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = items?[indexPath.row] {
            do {
                try self.realm.write {
                    item.isComplete = !item.isComplete!
                    
                    // If you need to delete items with complete state -> self.realm.delete(item)
                    
                    self.tableView.reloadData()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Append Item To List
    
    @IBAction func newTaskAction(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "New task creation", message: "Input task title", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add new item", style: .default, handler: { _ in
            if let currentBoard = self.selectedBoard {
                let newItem = ItemEntity()
                if let text = textField.text {
                    newItem.title = text
                    do {
                        try self.realm.write {
                            currentBoard.items.append(newItem)
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
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
    
    private func pushItemsToLocalDatabase(item: ItemEntity) {
        do {
            try self.realm.write {
                self.realm.add(item)
            }
        } catch {
            print(error.localizedDescription)
        }
        
        self.tableView.reloadData()
    }
    
    private func fetchItemsFromLocalDatabase() {
        self.items = selectedBoard?.items.sorted(byKeyPath: "title", ascending: true)
    }
}

// MARK: - UISearchBarDelegate
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        self.items = self.items?.filter(predicate)
        self.tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            self.fetchItemsFromLocalDatabase()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        } else {
            self.items = self.items?.filter("title CONTAINS[cd] %@", searchText).sorted(byKeyPath: "createdAt", ascending: true)
        }
        
        self.tableView.reloadData()
    }
}
