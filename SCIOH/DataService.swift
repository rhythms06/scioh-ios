//
//  DataService.swift
//  SCIOH
//
//  Created by Sakib Rasul and Romain Boudet on 15/02/16.
//  Copyright © 2016 Sakib Rasul/Romain Boudet. All rights reserved.
//

import Foundation
import Firebase

class DataService{
    static let dataService = DataService()

//    private var _BASE_REF = FIRDatabase.database().reference()
    
//    private var _USER_REF = Firebase(url: "https://scioh-app.firebaseio.com/users")
// 
//    
//    var BASE_REF: Firebase {
//        return _BASE_REF
//    }
//    
//    var USER_REF: Firebase {
//        return _USER_REF
//    }
//
//    var CURRENT_USER_REF: Firebase {
//        let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
//        
//        let currentUser = Firebase(url: "\(BASE_REF)").childByAppendingPath("users").childByAppendingPath(userID)
//        return currentUser!
//    }
//    
//    func createNewAccount(uid: String, user: Dictionary<String, String>) {
//        
//        // A User is born.
//        
//        USER_REF.childByAppendingPath(uid).setValue(user)
//    }


}
