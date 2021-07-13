//
//  Data.swift
//  Task Manager
//
//  Created by Sergei Romanchuk on 13.07.2021.
//

import Foundation
import RealmSwift

protocol BoardProtocol: Identifiable, Codable, Object {
    dynamic var id: String? { get }
    dynamic var title: String? { get set }
}

class BoardEntity: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
}
