//
//  PopUpViewController.swift
//  SCIOH
//
//  Created by Sakib Rasul on 11/26/16.
//  Copyright © 2016 Sakib Rasul. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class PopUpViewController:UIViewController {
    var ref : DatabaseReference! = Database.database().reference()
    @IBOutlet var popUpView: UIView!
    @IBOutlet var popUpBar: UINavigationBar!
    @IBOutlet var numFollowingLabel: UILabel!
    @IBOutlet var numPhotosLabel: UILabel!
    
    @IBOutlet var numFollowingLabel: UILabel!
    
    @IBOutlet var numPhotosLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        self.popUpView.layer.cornerRadius = 5
        self.popUpView.layer.shadowOpacity = 0.8
        self.popUpView.layer.shadowOffset = CGSize.init(width: 0.0, height: 0.0)
        self.view.frame.origin.y = UIScreen.main.bounds.size.height
    }
    
    func showInView(aView: UIView!, withTitle atitle: String!, animated: Bool) {
        aView.addSubview(self.view)
        popUpBar.topItem?.title = atitle
        
        let venueID = atitle.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ".", with: "")
        
        self.ref.child("Test/\(venueID)/attendees").observe(DataEventType.value, with: ({ (snapshot) in
            self.numFollowingLabel.text = "\(snapshot.childrenCount) Live"
        }))
        
        self.ref.child("Test/\(venueID)/images").observe(DataEventType.value, with: ({ (snapshot) in
            self.numPhotosLabel.text = "\(snapshot.childrenCount) Photos"
        }))
        
        if animated {
            self.showAnimate()
        }
    }
    
    func showAnimate() {
        UIView.animate(withDuration: 0.6, delay: 0.0, options: .curveEaseOut, animations: {
            // TODO: Currently, the background's dimensions are not calculated correctly
            // and UIColor.black.withAlphaComponent(0.6) does not fill the entire screen.
            // Fix this, and once it's fixed, undo the workaround used in PopUpView.xib!
            
//             self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            self.view.frame.origin.y -= (UIScreen.main.bounds.size.height - 85)
        }, completion: { finished in
            print("A popUpView suddenly appeared!")
        })
    }
    
    func hideAnimate() {
        UIView.animate(withDuration: 0.6, delay: 0.0, options: .curveEaseIn, animations: {
            // TODO: Currently, the background's dimensions are not calculated correctly
            // and UIColor.black.withAlphaComponent(0.6) does not fill the entire screen.
            // Fix this, and once it's fixed, undo the workaround used in PopUpView.xib!
            
//             self.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            self.view.frame.origin.y += UIScreen.main.bounds.size.height + 85
        }, completion: { finished in
            self.view.removeFromSuperview()
            print("A popUpView was dismissed!")
        })
    }
    
    @IBAction func closePopUp(_ sender: Any) {
        self.hideAnimate()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for tap in (event?.allTouches)! {
            // TODO: Make it so that touching the popup's title bar
            // does not dismiss the popup view.
            if tap.view == self.popUpView {
                print("The popUpView was tapped.")
            } else {
                print("The background of a popUpView was tapped.")
                self.hideAnimate()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
}
