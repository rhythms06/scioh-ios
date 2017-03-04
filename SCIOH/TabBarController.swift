//
//  TabBarController.swift
//  SCIOH
//
//  Created by Sakib Rasul on 6/1/16.
//  Copyright © 2016 Sakib Rasul. All rights reserved.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {
    
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
    
}
