//
//  SignUpPageViewController.swift
//  SCIOH
//
//  Created by Romain Boudet and Sakib Rasul on 15/02/16.
//  Copyright © 2016 Romain Boudet and Sakib Rasul. All rights reserved.
//

import UIKit
import Firebase

class SignUpPageViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var confirmPaswordTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    var ref : FIRDatabaseReference! = FIRDatabase.database().reference() //reference to database
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        emailTextField.delegate = self
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        confirmPaswordTextField.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func SignUpButtonTapped(_ sender: AnyObject) {
        let email = emailTextField.text
        let username = usernameTextField.text
        let password = passwordTextField.text
        let confirmed = confirmPaswordTextField.text
        
        
        if ((username != "") && (email != "") && (password != "") && (confirmed == password)) {
            
            FIRAuth.auth()?.createUser(withEmail: email!, password: password!, completion: { (user, error) in
                if error != nil {
                
                    let msg = "Either your email isn't correct, your password is too short, you aren't connected to the internet, or something else is broken. Sorry about that :P"
                    
//                    var msg : String
                    
//                    if let error = error as? Dictionary<AnyObject,AnyObject> {
                    
//                    switch error.userInfo[FIRAuthErrorNameKey] {
//                    case "ERROR_WEAK_PASSWORD":
//                        msg = "Your password must be at least six characters long."
//                    case "ERROR_NETWORK_REQUEST_FAILED":
//                        msg = "Uh-oh, the network connection seems to be broken. Check your settings, would you? :)"
//                    case "ERROR_INTERNAL_ERROR":
//                        msg = "Make sure your email is formatted correctly ;)"
//                    default:
//                        msg = "Something (\(error._userInfo?[FIRAuthErrorNameKey] as? String)) went wrong."
//                    }
                    
                    let alert = UIAlertController(title: "Error", message: msg, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                        
//                    }
                
                }

            
//            DataService.dataService.BASE_REF.createUser(email, password: password, withValueCompletionBlock: { error, result in
//             if error != nil {
//                
//                 let alert = UIAlertController(title: "Error", message: "there was a problem while creating your account", preferredStyle: UIAlertControllerStyle.Alert)
//                 alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: nil))
//                 self.presentViewController(alert, animated: true, completion: nil)
//                    
//              }
             
                    
             else {
                    
                    
                    
                    // Create and Login the New User with authUser
                    
                    
//                    
//                        DataService.dataService.BASE_REF.authUser(email, password: password, withCompletionBlock: { err, authData in
//                            let user = ["provider": authData.provider!, "email": email!, "username": username!]
//
//                            DataService.dataService.createNewAccount(authData.uid, user: user)
//                            
//                            
//                        })
                
                
                    
                    //add user (username and email) to database
                    

                    let toBeDatabased : Dictionary<String, Any> = ["username": String(describing: username!), "email": String(describing: email!), "fullname": ""]
                    
                    self.ref.child("users").child(user!.uid).setValue(toBeDatabased)
                    
                    
                    let alert = UIAlertController(title: "Success", message: "Welcome to SCIOH!", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Let's Go", style: UIAlertActionStyle.default, handler: nil))
                        
    //                self.presentViewController(alert, animated: true, completion: self.goToHome)
                    
                    self.performSegue(withIdentifier: "AccountCreated", sender: self)
                        
                    UserDefaults.standard.setValue(user?.uid, forKey: "uid")
                
                 }
             })
        }
        else {
            
            let alert = UIAlertController(title: "Error", message: "Your inputs are invalid, please enter valid information", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { // called when hitting "return" key
        textField.resignFirstResponder()
        return true
    }

    
    func goToHome(){
        
        let HomePage = self.storyboard?.instantiateViewController(withIdentifier: "HomePageViewController") as! HomePageViewController
        let HomePageNav = UINavigationController(rootViewController: HomePage)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = HomePageNav
        
    }
}
