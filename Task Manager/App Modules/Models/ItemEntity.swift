//
//  Item.swift
//  Task Manager
//
//  Created by Sergei Romanchuk on 08.07.2021.
//

import Foundation
import RealmSwift

protocol ItemProtocol: Identifiable {
    var id: String? { get }
    var title: String? { get set }
    var isComplete: Bool? { get set }
}

class ItemEntity: Object, ItemProtocol {
    @Persisted var id: String?
    @Persisted var title: String?
    @Persisted var isComplete: Bool?
    @Persisted var createdAt: TimeInterval?
    var parent: LinkingObjects = LinkingObjects(fromType: BoardEntity.self, property: "items")
    
    override init() {
        super.init()
        self.id = UUID().uuidString
        self.isComplete = false
        self.createdAt = Date().timeIntervalSince1970
    }
}
