//
//  SwipeTableViewController.swift
//  Task Manager
//
//  Created by Sergei Romanchuk on 13.07.2021.
//

import UIKit
import SwipeCellKit
import RealmSwift

class SwipeTableViewController: UITableViewController {
    private let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
    }
    
    func updateModel(at indexPath: IndexPath) {
        // Update data model
    }
}

// MARK: - TableViewDataSource Methods
extension SwipeTableViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        return cell
    }
}

// MARK: - UITableViewDelegate Methods
extension SwipeTableViewController {
    
}

// MARK: - SwipeTableViewCellDelegate Methods
extension SwipeTableViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else {
            return nil
        }
        
        let deleteAction = SwipeAction(style: .default, title: "Delete") { swipeAction, indexPath in
            self.updateModel(at: indexPath)
        }
        deleteAction.backgroundColor = .red
        deleteAction.image = UIImage(systemName: "trash")
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        
        // If in app used more than one option -> options.transitionStyle = .border
        
        return options
    }
}
