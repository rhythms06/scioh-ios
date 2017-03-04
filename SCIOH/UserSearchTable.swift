//
//  UserSearchTable.swift
//  SCIOH
//
//  Created by Sakib Rasul on 9/22/16.
//  Copyright © 2016 Sakib Rasul. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class UserSearchTable : UITableViewController {
    var ref : FIRDatabaseReference! = FIRDatabase.database().reference()
    var matchingItems:[String] = []
//    var userExists = false
    
    var fullName = ""
    var uid = ""
    
    let userSegueIdentifier = "ShowProfileSegue"
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == userSegueIdentifier,
            let destination = segue.destination as? ExtProfileViewController
            {
                destination.userFullName = fullName
                destination.useruid = uid
            }
    }
}

extension UserSearchTable : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBarText = searchController.searchBar.text
        self.ref.child("users").queryOrdered(byChild: "username").queryEqual(toValue: searchBarText).observe(FIRDataEventType.value, with: ({ (snapshot) in
            if snapshot.hasChildren() {
                let userDict = snapshot.value as! Dictionary<String, Any>
                for (id, detail) in userDict {
                    let details = detail as! Dictionary<String, Any>
//                    print("username \"\(details["username"])\" exists with fullname \"\(details["fullname"])\"")
                    self.matchingItems = [details["username"] as! String, details["fullname"] as! String]
                    
                    self.fullName = details["fullname"] as! String
                    
                    self.uid = id
                    
                }
            } else {
                self.matchingItems = ["No user with that username found :P", ""]
            }
            self.tableView.reloadData()
        }))
    }
}

extension UserSearchTable {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        if matchingItems.isEmpty {
            cell.textLabel?.text = "Searching..."
            cell.detailTextLabel?.text = ""
        } else {
            cell.textLabel?.text = matchingItems[0]
            cell.detailTextLabel?.text = matchingItems[1]
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if matchingItems[0] != "Searching..." && matchingItems[0] != "No user with that username found :P" {
            print("I cannot yet access \(matchingItems[0])'s profile.")
        }
    }
}
