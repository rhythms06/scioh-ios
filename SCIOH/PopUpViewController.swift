//
//  PopUpViewController.swift
//  SCIOH
//
//  Created by Sakib Rasul on 11/26/16.
//  Copyright © 2016 Sakib Rasul. All rights reserved.
//

import Foundation
import UIKit

class PopUpViewController:UIViewController {
    
    
    
    @IBOutlet var popUpView: UIView!
    
    @IBOutlet var popUpBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        self.popUpView.layer.cornerRadius = 5
        self.popUpView.layer.shadowOpacity = 0.8
        self.popUpView.layer.shadowOffset = CGSize.init(width: 0.0, height: 0.0)
        self.popUpView.frame.origin.y = UIScreen.main.bounds.size.height
    }
    
    func showInView(aView: UIView!, withTitle atitle: String!, animated: Bool) {
        aView.addSubview(self.view)
        popUpBar.topItem?.title = atitle
        if animated {
            self.showAnimate()
        }
    }
    
    func showAnimate() {
        UIView.animate(withDuration: 0.6, delay: 0.0, options: .curveEaseOut, animations: {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            self.popUpView.frame.origin.y -= (UIScreen.main.bounds.size.height)
        }, completion: { finished in
            print("A popUpView suddenly appeared!")
        })
    }
    
    func hideAnimate() {
        UIView.animate(withDuration: 0.6, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            self.popUpView.frame.origin.y += UIScreen.main.bounds.size.height
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
