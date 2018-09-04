//
//  AccountSettingsViewController.swift
//  SCIOH
//
//  Created by Sakib Rasul on 9/20/16.
//  Copyright © 2016 Sakib Rasul. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class AccountSettingsViewController: UITableViewController, UITextFieldDelegate {
    
    var ref : DatabaseReference! = Database.database().reference()
    
    @IBOutlet var fullNameTextField: UITextField!
    
    let uid = UserDefaults.standard.value(forKey: "uid")!
    
    override func viewDidLoad() {
        self.navigationItem.title = "My Account"
        self.fullNameTextField.delegate = self
        
        ref.child("users").child(uid as! String).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let ssnapshot = snapshot.value! as! [String : Any]
            let fullName = ssnapshot["fullname"]
            self.fullNameTextField.text = fullName as! String?
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.ref.child("users/\(uid)/fullname").setValue(fullNameTextField.text! as String)
        self.fullNameTextField.resignFirstResponder()
        return true
    }
    
}
