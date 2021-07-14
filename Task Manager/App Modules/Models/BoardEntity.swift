//
//  Data.swift
//  Task Manager
//
//  Created by Sergei Romanchuk on 13.07.2021.
//

import Foundation
import RealmSwift
import ChameleonFramework

// MARK: - Board Protocol
protocol BoardProtocol: Identifiable {
    var id: String? { get }
    var name: String? { get set }
}

// MARK: - Board Entity Class (Using Realm)
class BoardEntity: Object, BoardProtocol {
    @objc dynamic var id: String?
    @objc dynamic var name: String?
    @objc dynamic var hex: String?
    var items: List<ItemEntity> = List<ItemEntity>()
    
    override init() {
        super.init()
        self.id = UUID().uuidString
        self.hex = UIColor.randomFlat().hexValue()
    }
}
