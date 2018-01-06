//
//  Category.swift
//  todoey
//
//  Created by Apple on 10/14/1396 AP.
//  Copyright © 1396 AP Amin Torabi. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name :String = ""
    let items = List<Item>()
}
