//
//  ProfileViewController.swift
//  SCIOH
//
//  Created by Romain Boudet and Sakib Rasul on 14/02/16.
//  Copyright © 2016 Romain Boudet and Sakib Rasul. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet var fullNameLabel: UILabel!
    
    let uid = FIRAuth.auth()?.currentUser?.uid
//    var base64String: NSString!
    
    var ref : FIRDatabaseReference! = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ref.child("users").child(uid!).observe(FIRDataEventType.value, with: ({ (snapshot) in
            // retrieve user info
            let ssnapshot = snapshot.value! as! [String : Any]
            let fullName = ssnapshot["fullname"]
            self.fullNameLabel.text = fullName as! String?
        }))
        
        
        
        //view.bringSubviewToFront(mainButton)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(ProfileViewController.handleSwipes(_:)))
        
        rightSwipe.direction = .right
        
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(ProfileViewController.handleSwipes(_:)))
        
        leftSwipe.direction = .left
    
//        let ref = Firebase(url: "https://scioh.firebaseio.com/users/\(uid)/Profile_Picture")
       
//        ref.observeEventType(.Value, withBlock: { snapshot in
//        
//         if snapshot.hasChild("image") {
//               let temp = snapshot.value
//               self.base64String = temp.valueForKey("image") as! NSString
//           
//               let decodedData = NSData(base64EncodedString: self.base64String as String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
//            
//                let decodedImage = UIImage(data: decodedData!)
//            
//               self.profilePhoto.image = decodedImage
//            
//            }
//        })
       
        
//        profilePhoto.contentMode = .scaleAspectFit
//        profilePhoto.layer.borderWidth = 1.0
//        profilePhoto.layer.masksToBounds = false
//        profilePhoto.layer.borderColor = UIColor.white.cgColor
//        profilePhoto.layer.cornerRadius = profilePhoto.frame.size.width/2
//        profilePhoto.clipsToBounds = true

        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func handleSwipes(_ sender: UISwipeGestureRecognizer){
        if (sender.direction == .right){
            self.performSegue(withIdentifier: "ProfileToCameraSwipe", sender: self)
        }
        if (sender.direction == .left){
            self.performSegue(withIdentifier: "ProfileToHomeSwipe", sender: self)
        }
        
        
    }

    
    
    
    
    
    

    @IBAction func LogOutButtonTapped(_ sender: AnyObject) {
        
//        DataService.dataService.CURRENT_USER_REF.unauth()
        
        
        UserDefaults.standard.setValue(nil, forKey: "uid")
        
      /*  let LoginPage = self.storyboard?.instantiateViewControllerWithIdentifier("Login") as! LoginPageViewController
        let LoginPageNav = UINavigationController(rootViewController: LoginPage)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.rootViewController = LoginPageNav*/

    }
    
    @IBAction func changePhotoTapped(_ sender: AnyObject) {
        
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true, completion: nil)

    }
    
    
    
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
//        
//        self.dismiss(animated: true, completion: nil)
//        
//        profilePhoto.image = image
//        
//        let uploadImage = image
//        let imageData = UIImagePNGRepresentation(uploadImage)!
//        self.base64String = imageData.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters)
//        
//        
////        let ref = Firebase(url: "https://scioh.firebaseio.com/users/\(uid)")
//        
//        let image = ["image": self.base64String]
////        ref.childByAppendingPath("Profile_Picture").setValue(image)
//        
//    }
    
//    func getDocumentsDirectory() -> NSString {
//        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
//        let documentsDirectory = paths[0]
//        return documentsDirectory
//    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
       dismiss(animated: true, completion: nil)
   }
    
    
  
    
    
    
}
