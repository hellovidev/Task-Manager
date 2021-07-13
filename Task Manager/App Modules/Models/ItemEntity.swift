//
//  Item.swift
//  Task Manager
//
//  Created by Sergei Romanchuk on 08.07.2021.
//

import Foundation

protocol ItemProtocol: Identifiable, Codable {
    var id: String? { get }
    var title: String? { get set }
    var isComplete: Bool? { get set }
}

struct Item: ItemProtocol {
    var id: String?
    
    var title: String?
    
    var isComplete: Bool?
    
    init() {
        self.id = UUID().uuidString
        self.isComplete = false
    }
}
