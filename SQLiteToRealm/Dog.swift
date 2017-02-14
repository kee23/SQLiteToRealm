//
//  Dog.swift
//  SQLiteToRealm
//
//  Created by Harkeerat Toor on 2/14/17.
//  Copyright © 2017 Kiefer Consulting, Inc. All rights reserved.
//

import Foundation
import RealmSwift

// Dog model
class Dog: Object {
    dynamic var id = 0
    dynamic var name = ""
    dynamic var breed = ""
    dynamic var owner: Person? // Properties can be optional
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
