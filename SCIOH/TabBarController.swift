//
//  TabBarController.swift
//  SCIOH
//
//  Created by Sakib Rasul on 6/1/16.
//  Copyright © 2016 Sakib Rasul. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class TabBarController: UITabBarController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let storageRef = FIRStorage.storage().reference()
    var ref : FIRDatabaseReference! = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        
        UITabBar.appearance().barTintColor = UIColor.white
        
        let tabBar = self.tabBar
        
        let mapSelectImage: UIImage! = UIImage(named: "map (s)")?.withRenderingMode(.alwaysOriginal)
        let notifsSelectImage: UIImage! = UIImage(named: "cup (s)")?.withRenderingMode(.alwaysOriginal)
        let picSelectImage: UIImage! = UIImage(named: "camera (s)")?.withRenderingMode(.alwaysOriginal)
        let proSelectImage: UIImage! = UIImage(named: "Profile (s)")?.withRenderingMode(.alwaysOriginal)
        let calSelectImage: UIImage! = UIImage(named: "Event (s)")?.withRenderingMode(.alwaysOriginal)
        
        tabBar.items![0].selectedImage = mapSelectImage
        tabBar.items![1].selectedImage = notifsSelectImage
        tabBar.items![2].selectedImage = picSelectImage
        tabBar.items![3].selectedImage = proSelectImage
        tabBar.items![4].selectedImage = calSelectImage
        
        tabBar.isTranslucent = false
        
//        tabBar.tintColor = UIColor(red: 10/255, green: 57/255, blue: 106/255, alpha: 1.0) /* #0a396a */

        
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        //TODO: Embed camera view into navigation controller
        
        if item == (self.tabBar.items! as [UITabBarItem])[2] {
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
                imagePicker.allowsEditing = false
                self.modalPresentationStyle = .currentContext
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("did finish taking pic")
        if let pickedImage = info[UIImagePickerControllerOriginalImage]{
            // Create a reference to the file you want to upload
            
            print("finding user's location")
            
            var location = ""
            
            print("uid is \(UserDefaults.standard.value(forKey: "uid") as! String)")
            
            self.ref.child("users").child(UserDefaults.standard.value(forKey: "uid") as! String).observeSingleEvent(of: .value, with: { (snapshot) in
                print("searching database...")
                
                let value = snapshot.value as? NSDictionary
                location = value?["location"] as! String
                
                
                if(location != "") {
                    print("uploading photo to \(location)...")
                    
                    var data = Data()
                    data = UIImageJPEGRepresentation(pickedImage as! UIImage, 0.8)!
                    
                    let uuid = UUID().uuidString
                    
                    let imageRef = self.storageRef.child("images/\(location)").child("\(uuid).jpg")
                    
                    let metaData = FIRStorageMetadata()
                    metaData.contentType = "image/jpg"
                    
                    // Upload the file
                    _ = imageRef.put(data, metadata: metaData) { metaData, error in
                        if error != nil {
                            print("Uh-oh, an error occurred while uploading the image!")
                        } else {
                            // Metadata contains file metadata such as size, content-type, and download URL.
                            let downloadURL = metaData!.downloadURL()!.absoluteString
                            print("Success! The image can be found at \(downloadURL).")
                            
                            self.ref.child("users/\(UserDefaults.standard.value(forKey: "uid") as! String)/images/\(uuid)").setValue(downloadURL)
                            self.ref.child("Test/\(location)/images/\(uuid)").setValue(downloadURL)
                            
                            
                            //TODO: Add image URL to users/USERID/images/uuid and Test/VenueID/images/uuid
                        }
                    }
                    
                }

            }) { (error) in
                print(error.localizedDescription)
            }
        } else {
            print("An error occurred while uploading the image.")
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
}