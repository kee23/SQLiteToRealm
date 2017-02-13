//
//  SQLiteToRealmModel.swift
//  SQLiteToRealm
//
//  Created by Harkeerat Toor on 1/3/16.
//  Copyright © 2016 kee. All rights reserved.
//

import UIKit
import RealmSwift

class SQLiteToRealmModel: NSObject {
    
    var sqliteFilename: String
    var sqliteExtension: String
    
    init(dbFilename: String, dbExtention: String) {
        sqliteFilename = dbFilename
        sqliteExtension = dbExtention
    }
    
    
    func loadFromDB(_ query: String, realm: Realm)
    {
        let fileURL = Bundle.main.path(forResource: sqliteFilename, ofType:sqliteExtension)
        
        // Open SQLite database
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL!, &db) == SQLITE_OK {
            
            // Run SELECT query from db
            var statement: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
                
                // Create realm object
                let realm = try! Realm()
                
                // Delete all objects from the realm
                try! realm.write {
                    realm.deleteAll()
                }
                
                // Loop through all results from query
                while sqlite3_step(statement) == SQLITE_ROW {
                    
                    // Create object for Realm
                    let realmInfoItem = SampleRealmObject()
                    
                    let id = sqlite3_column_int64(statement, 0)
                    print("id = \(id); ", terminator: "")
                    realmInfoItem.id = Int(id)
                    
                    let title = sqlite3_column_text(statement, 1)
                    if title != nil {
                        let titleString = String(cString:title!)
                        print("title = \(titleString); ", terminator: "")
                        realmInfoItem.title = titleString
                    } else {
                        print("title not found", terminator: "")
                    }
                    
                    let subtitle = sqlite3_column_text(statement, 2)
                    if subtitle != nil {
                        let subtitleString = String(cString:subtitle!)
                        print("subtitle = \(subtitleString); ", terminator: "")
                        realmInfoItem.subtitle = subtitleString
                    } else {
                        print("subtitle not found", terminator: "")
                    }
                    
                    let number = sqlite3_column_int64(statement, 3)
                    print("number = \(number);")
                    realmInfoItem.number = Int(number)
                    
                    // Add to the Realm inside a transaction
                    try! realm.write {
                        realm.add(realmInfoItem)
                    }
                }
                
            }
            else {
                let errmsg = String(cString: sqlite3_errmsg(db))
                print("error running query: \(errmsg)")
            }
            
            let defaultRealmPath = Realm.Configuration.defaultConfiguration.fileURL?.deletingLastPathComponent().appendingPathComponent("default-compact.realm")
            
            do {
                try FileManager.default.removeItem(atPath: (defaultRealmPath?.path)!)
            } catch let error as NSError {
                print(error.debugDescription)
            }
            
            try! Realm().writeCopy(toFile: (defaultRealmPath! as NSURL) as URL)
            
            print("Finished Migration: \(defaultRealmPath)")
        }
        else {
            print("error opening database")
        }
    }
    
}
