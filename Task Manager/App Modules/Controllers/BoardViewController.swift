//
//  BoardViewController.swift
//  Task Manager
//
//  Created by Sergei Romanchuk on 09.07.2021.
//

import UIKit
import RealmSwift

class BoardViewController: UITableViewController {
    private let realm = try! Realm()
    private var boards: Results<BoardEntity>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchBoardsFromLocalDatabase()
    }
    
    // MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.boards?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BoardCell", for: indexPath)
        cell.textLabel?.text = boards?[indexPath.row].name
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToBoard", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - NavigationView Delegate Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToBoard" {
            if let destinationVC = segue.destination as? TodoListViewController, let indexPath = self.tableView.indexPathForSelectedRow {
                destinationVC.selectedBoard = boards?[indexPath.row]
            }
        }
    }
    
    // MARK: - Data Manipulation Methods
    
    @IBAction func newBoardAction(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "New board creation", message: "Input board name", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add new board", style: .default, handler: { _ in
            let newBoard = BoardEntity()
            
            if let textOfBoardName = textField.text {
                newBoard.name = textOfBoardName
                self.pushDataToLocalDatabase(board: newBoard)
            }
        })
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new board..."
            textField = alertTextField
        }
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Core Data Methods
    
    private func fetchBoardsFromLocalDatabase() {
        self.boards = realm.objects(BoardEntity.self)
    }
    
    private func pushDataToLocalDatabase(board: BoardEntity) {
        do {
            try self.realm.write {
                realm.add(board)
            }
            self.tableView.reloadData()
        } catch {
            print("Push data about boards to local database error: \(error.localizedDescription)")
        }
    }
}
