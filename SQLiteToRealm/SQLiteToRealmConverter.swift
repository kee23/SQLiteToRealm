//
//  SQLiteToRealmConverter.swift
//  SQLiteToRealm
//
//  Created by Harkeerat Toor on 2/14/17.
//  Copyright © 2017 kee. All rights reserved.
//

import UIKit
import RealmSwift

class SQLiteToRealmConverter: NSObject {
    
    var fileURL: String?
    
    init(dbFilename: String, dbExtention: String) {
        fileURL = Bundle.main.path(forResource: dbFilename, ofType:dbExtention)
    }
    
    func loadFromDB(_ realm: Realm)
    {
        // Create realm object
        let realm = try! Realm()
        
        // Delete all objects from the realm
        try! realm.write {
            realm.deleteAll()
        }
        
        loadPersonsTable(realm)
        loadDogsTable(realm)
        
        let defaultRealmPath = Realm.Configuration.defaultConfiguration.fileURL?.deletingLastPathComponent().appendingPathComponent("default-compact.realm")
        
        do {
            try FileManager.default.removeItem(atPath: (defaultRealmPath?.path)!)
        } catch let error as NSError {
            print(error.debugDescription)
        }
        
        try! Realm().writeCopy(toFile: (defaultRealmPath! as NSURL) as URL)
        
        print("Finished Migration: \(defaultRealmPath!)")
    }
    
    private func loadPersonsTable(_ realm: Realm) {
        let query = "select * from Person"
        
        // Open SQLite database
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL, &db) == SQLITE_OK {
            
            // Run SELECT query from db
            var statement: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
                
                // Loop through all results from query
                while sqlite3_step(statement) == SQLITE_ROW {
                    
                    // Create object for Realm
                    let realmPersonItem = Person()
                    
                    let id = sqlite3_column_int64(statement, 0)
                    print("id = \(id); ", terminator: "")
                    realmPersonItem.id = Int(id)
                    
                    let name = sqlite3_column_text(statement, 1)
                    if name != nil {
                        let nameString = String(cString:name!)
                        print("name = \(nameString); ", terminator: "")
                        realmPersonItem.name = nameString
                    } else {
                        print("name not found", terminator: "")
                    }
                    
                    let birthdate = sqlite3_column_text(statement, 2)
                    if birthdate != nil {
                        let birthdateString = String(cString:birthdate!)
                        print("birthdate = \(birthdateString); ", terminator: "")
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MM-dd-yyyy"
                        realmPersonItem.birthdate = dateFormatter.date(from: birthdateString)!
                    } else {
                        print("birthdate not found", terminator: "")
                    }
                    
                    // Add to the Realm inside a transaction
                    try! realm.write {
                        realm.add(realmPersonItem)
                    }
                }
                
            }
            else {
                let errmsg = String(cString: sqlite3_errmsg(db))
                print("error running query: \(errmsg)")
            }
        }
        else {
            print("error opening database")
        }
    }
    
    private func loadDogsTable(_ realm: Realm) {
        let query = "select * from Dog"
        
        // Open SQLite database
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL, &db) == SQLITE_OK {
            
            // Run SELECT query from db
            var statement: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
                
                // Create realm object
                let realm = try! Realm()
                
                // Loop through all results from query
                while sqlite3_step(statement) == SQLITE_ROW {
                    
                    // Create object for Realm
                    let realmDogItem = Dog()
                    
                    let id = sqlite3_column_int64(statement, 0)
                    print("id = \(id); ", terminator: "")
                    realmDogItem.id = Int(id)
                    
                    let name = sqlite3_column_text(statement, 1)
                    if name != nil {
                        let nameString = String(cString:name!)
                        print("name = \(nameString); ", terminator: "")
                        realmDogItem.name = nameString
                    } else {
                        print("name not found", terminator: "")
                    }
                    
                    let breed = sqlite3_column_text(statement, 2)
                    if breed != nil {
                        let breedString = String(cString:breed!)
                        print("breed = \(breedString); ", terminator: "")
                        realmDogItem.breed = breedString
                    } else {
                        print("breed not found", terminator: "")
                    }
                    
                    let owner = sqlite3_column_text(statement, 3)
                    if owner != nil {
                        let ownerString = String(cString:owner!)
                        print("owner = \(ownerString); ", terminator: "")
                        let thePerson = realm.objects(Person.self).filter("id == \(ownerString)").first
                        realmDogItem.owner = thePerson
                    } else {
                        print("owner not found", terminator: "")
                    }
                    
                    // Add to the Realm inside a transaction
                    try! realm.write {
                        realm.add(realmDogItem)
                    }
                }
            }
            else {
                let errmsg = String(cString: sqlite3_errmsg(db))
                print("error running query: \(errmsg)")
            }
        }
        else {
            print("error opening database")
        }
    }
    
}
