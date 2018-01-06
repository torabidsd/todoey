//
//  Item.swift
//  todoey
//
//  Created by Apple on 10/14/1396 AP.
//  Copyright © 1396 AP Amin Torabi. All rights reserved.
//

import Foundation
import RealmSwift
class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated: Date?
    let parentCategory = LinkingObjects(fromType: Category.self, property:"items")
}
