//
//  Category.swift
//  ToDoey
//
//  Created by Anand Nigam on 15/08/18.
//  Copyright © 2018 Anand Nigam. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    
    // To define relationships in Realm
    // Forward relationship (each category having a list of items)
    let items = List<Item>()
}
