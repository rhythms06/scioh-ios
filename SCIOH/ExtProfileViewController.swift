//
//  ExtProfileViewController.swift
//  SCIOH
//
//  Created by Sakib Rasul on 12/28/16.
//  Copyright © 2016 Sakib Rasul. All rights reserved.
//

import Foundation
import Firebase

class ExtProfileViewController : UIViewController {
    @IBOutlet var userFullNameLabel: UILabel!
    
    var ref : FIRDatabaseReference! = FIRDatabase.database().reference()
    
    let uid = UserDefaults.standard.value(forKey: "uid")!
    
    var userFullName : String = ""
    
    var useruid : String = ""
    
    @IBOutlet var addFriend: UIButton!
    
    
    override func viewWillAppear(_ animated: Bool) {
        userFullNameLabel.text = userFullName
        
    }
    
    @IBAction func addFriendButton(_ sender: Any) {
        if(addFriend.currentTitle == "Add Friend") {
            addFriend.setTitle("Request Sent", for: UIControlState.normal)
            self.ref.child("users/\(uid)/friends").setValue(["\(useruid)": false])
            self.ref.child("users/\(useruid)/friends").setValue(["\(uid)":false])
            print("You just sent User \(useruid) a friend request")
        }
    }
}
