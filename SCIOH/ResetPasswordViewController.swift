//
//  ResetPasswordViewController.swift
//  SCIOH
//
//  Created by Romain Boudet on 15/02/16.
//  Copyright © 2016 Romain Boudet. All rights reserved.
//

import UIKit
import Firebase

class ResetPasswordViewController: UIViewController {
    
    @IBAction func ResetButtonTapped(_ sender: AnyObject) {
        
        let email = emailTextField.text
        
        Auth.auth().sendPasswordReset(withEmail: email!) { error in
            if (error != nil) {
                let alert = UIAlertController(title: "Error", message: "email was incorrect", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: self.goToLogin)
            } else {
                let alert = UIAlertController(title: "Email Sent", message: "Refer to the email for further instructions", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                

            }
        }
        
        
//        let ref = Firebase(url: "https://scioh.firebaseio.com/")
//        ref.resetPasswordForUser(emailTextField.text, withCompletionBlock: { error in
//            if error != nil {
//                let alert = UIAlertController(title: "Error", message: "email was incorrect", preferredStyle: UIAlertControllerStyle.Alert)
//                alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: nil))
//                self.presentViewController(alert, animated: true, completion: self.goToLogin)
//
//
//                
//            } else {
//                
//                let alert = UIAlertController(title: "Email Sent", message: "Refer to the email for further instructions", preferredStyle: UIAlertControllerStyle.Alert)
//                alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: nil))
//                self.presentViewController(alert, animated: true, completion: nil)
//                
//                self.emailTextField.text = ""
//
//            
//            }
//        })

    }
    
    
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goToLogin(){
        
        let LoginPage = self.storyboard?.instantiateViewController(withIdentifier: "Login") as! LoginPageViewController
        let LoginPageNav = UINavigationController(rootViewController: LoginPage)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = LoginPageNav

    }

}
