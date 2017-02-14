//
//  Person.swift
//  SQLiteToRealm
//
//  Created by Harkeerat Toor on 2/14/17.
//  Copyright © 2017 Kiefer Consulting, Inc. All rights reserved.
//

import Foundation
import RealmSwift

// Person model
class Person: Object {
    dynamic var id = 0
    dynamic var name = ""
    dynamic var birthdate = Date()
    let dogs = LinkingObjects(fromType: Dog.self, property: "owner")
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
