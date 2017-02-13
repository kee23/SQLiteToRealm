//
//  ViewController.swift
//  SQLiteToRealm
//
//  Created by Harkeerat Toor on 1/3/16.
//  Copyright © 2016 kee. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var dbManager: SQLiteToRealmModel!
    // Create realm object
    var realm: Realm!
    var objects: Results<(SampleRealmObject)>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        dbManager = SQLiteToRealmModel(dbFilename: "sampledb", dbExtention: "db")
        realm = try! Realm()
        loadData()
    }
    
    fileprivate func loadData()
    {
        let query = "select * from SampleInfo"
        dbManager.loadFromDB(query, realm:realm)
        objects = realm.objects(SampleRealmObject.self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel!.text = objects[indexPath.row].title
        cell.detailTextLabel!.text = objects[indexPath.row].subtitle
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        self.tableView = nil
    }
    
}
