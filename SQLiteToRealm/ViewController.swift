//
//  ViewController.swift
//  SQLiteToRealm
//
//  Created by Harkeerat Toor on 1/3/16.
//  Copyright © 2017 Kiefer Consulting, Inc. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var dbManager: SQLiteToRealmConverter!
    // Create realm object
    var realm: Realm!
    var persons: Results<(Person)>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        dbManager = SQLiteToRealmConverter(dbFilename: "sample", dbExtention: "db")
        realm = try! Realm()
        loadData()
    }
    
    fileprivate func loadData()
    {
        dbManager.loadFromDB(realm)
        persons = realm.objects(Person.self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        cell.textLabel!.text = "\(persons[indexPath.row].name) -- \(dateFormatter.string(from: persons[indexPath.row].birthdate)) "
        
        var dogsList: Array<String> = []
        for dog in persons[indexPath.row].dogs {
            dogsList.append("\(dog.name) : \(dog.breed)")
        }
        cell.detailTextLabel!.text = "Dogs: \(dogsList)"
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        self.tableView = nil
    }
    
}
