//
//  Item.swift
//  ToDoey
//
//  Created by Anand Nigam on 15/08/18.
//  Copyright © 2018 Anand Nigam. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    
    // To define relationships in Realm
    // Reverse relationship (each item having a parentCategory)
    let parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
