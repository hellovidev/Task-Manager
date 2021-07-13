//
//  Data.swift
//  Task Manager
//
//  Created by Sergei Romanchuk on 13.07.2021.
//

import Foundation
import RealmSwift

protocol BoardProtocol: Identifiable {
    dynamic var id: String? { get }
    dynamic var name: String? { get set }
}

class BoardEntity: Object, BoardProtocol {
    @objc dynamic var id: String?
    @objc dynamic var name: String?
    var items: List<ItemEntity> = List<ItemEntity>()
    
    override init() {
        super.init()
        self.id = UUID().uuidString
    }
}
