//
//  Data.swift
//  ToDoey
//
//  Created by Anand Nigam on 14/08/18.
//  Copyright © 2018 Anand Nigam. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    
    @objc dynamic var name:String = ""
    @objc dynamic var age:Int = 0
}
