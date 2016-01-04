//
//  SampleRealmObject.swift
//  SQLiteToRealm
//
//  Created by Harkeerat Toor on 1/3/16.
//  Copyright © 2016 kee. All rights reserved.
//

import UIKit
import RealmSwift

class SampleRealmObject: Object {
    dynamic var id = 0
    dynamic var title = ""
    dynamic var subtitle = ""
    dynamic var number = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}