//
//  LoginPageViewController.swift
//  SCIOH
//
//  Created by Romain Boudet and Sakib Rasul on 15/02/16.
//  Copyright © 2016 Romain Boudet and Sakib Rasul. All rights reserved.
//

import UIKit
import Firebase

class LoginPageViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordtextField: UITextField!
    
    @IBOutlet var keyboardConstraint: NSLayoutConstraint!
    
    @IBOutlet var keyboardConstraint2: NSLayoutConstraint!
    
    var keyboardShowing = false
    
    var emailTapped = false
    
    var passTapped = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginPageViewController.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(LoginPageViewController.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
        
        emailTextField.delegate = self
        passwordtextField.delegate = self
        
        emailTextField.addTarget(self, action: #selector(LoginPageViewController.emailWasTapped(_:)), for: UIControlEvents.touchDown)
        
        passwordtextField.addTarget(self, action: #selector(LoginPageViewController.passWasTapped(_:)), for: UIControlEvents.touchDown)
        
        
//        if (NSUserDefaults.standardUserDefaults().valueForKey("uid") != nil) && (DataService.dataService.CURRENT_USER_REF.authData != nil) {
//        if (NSUserDefaults.standardUserDefaults().valueForKey("uid") != nil) {
//            print("authdata : \(DataService.dataService.CURRENT_USER_REF.authData)")
            
            // USER IS LOGGED IN ALREADY. TAKE 'EM STRAIGHT TO THE MAP, NOT BACK TO LOGIN!
            
//            self.performSegueWithIdentifier("AlreadyLoggedIn", sender: self)
            
//                let HomePage = self.storyboard?.instantiateViewControllerWithIdentifier("NavController") as! UINavigationController
//                let HomePageNav = UINavigationController(rootViewController: HomePage)
//                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//                appDelegate.window?.rootViewController = HomePageNav
//            print("user is logged in already!!!!")
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (UserDefaults.standard.value(forKey: "uid") != nil) {
            self.performSegue(withIdentifier: "AlreadyLoggedIn", sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func emailWasTapped(_ textField: UITextField) {
        // user touch field
        emailTapped = true
    }
    
    func passWasTapped(_ textField: UITextField) {
        // user touch field
        passTapped = true
    }
    
    func keyboardWillShow(_ sender: Notification) {
        if(!keyboardShowing) {
            
            NSLayoutConstraint.activate([keyboardConstraint, keyboardConstraint2])
            
            var info = (sender as NSNotification).userInfo!
            let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue

            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                if(self.emailTapped) {
                    self.emailTapped = false
                    self.keyboardConstraint.constant = keyboardFrame.size.height + 20
                }
                if(self.passTapped) {
                    self.passTapped = false
                    self.keyboardConstraint2.constant = keyboardFrame.size.height
                }
            })
            
            keyboardShowing = true
        }
    }
    
    func keyboardWillHide(_ sender: Notification) {
        if(keyboardShowing) {
            NSLayoutConstraint.deactivate([keyboardConstraint, keyboardConstraint2])
            keyboardShowing = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func LoginButtonTapped(_ sender: AnyObject) {
        let email = emailTextField.text
        let password = passwordtextField.text
        
        if ((email != "" ) && (password != "")) {
            
            FIRAuth.auth()?.signIn(withEmail: email!, password: password!) { (user, error) in
                if error != nil {
                    let alert = UIAlertController(title: "Error", message: "Incorrect email address and/or password.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                    //                    self.passwordtextField.text = ""
                }
                else {
                    print("\(user)")
                    UserDefaults.standard.setValue(user!.uid, forKey: "uid")
                    self.performSegue(withIdentifier: "AlreadyLoggedIn", sender: self)
                }

            }
            
//            DataService.dataService.BASE_REF.authUser(email, password: password, withCompletionBlock: { error, authData in
//                if error != nil {
//                    let alert = UIAlertController(title: "Error", message: "Incorrect email/username and/or password.", preferredStyle: UIAlertControllerStyle.Alert)
//                    alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: nil))
//                    self.presentViewController(alert, animated: true, completion: nil)
//                    
////                    self.passwordtextField.text = ""
//                }
//                else {
//                    print("\(authData)")
//                     NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: "uid")
//                    self.performSegueWithIdentifier("AlreadyLoggedIn", sender: self)
//                }
//            })
            
            
        }
        else {
            let alert = UIAlertController(title: "Error", message: "Please enter your email/username and password.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    

}
