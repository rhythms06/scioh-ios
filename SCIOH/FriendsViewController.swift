//
//  FriendsViewController.swift
//  SCIOH
//
//  Created by Sakib Rasul on 6/30/16.
//  Copyright © 2016 Sakib Rasul. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class FriendsViewController : UITableViewController {
    
    var numUsers = 0
    let users:NSMutableArray = []
    
    override func viewDidLoad() {
        
        self.navigationItem.title = "Friends"
        
        tableView.dataSource = self
        
        let ref = FIRDatabase.database().reference()
        
        ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            for uid in snapshot.value! as! Dictionary<String, AnyObject> {
                
                self.numUsers += 1
                
                self.users.add(uid.value["username"] as! String)
                
                self.tableView.reloadData()
                
            }
        })
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        if(users.count != 0 && indexPath.row <= users.count - 1) {

            cell.textLabel?.text = (users[indexPath.row] as! String)
        
        }
        
        return cell
    }
}


