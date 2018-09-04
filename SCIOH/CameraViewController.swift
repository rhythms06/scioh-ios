//
//  CameraViewController.swift
//  SCIOH
//
//  Created by Romain Boudet on 18/02/16.
//  Copyright © 2016 Romain Boudet. All rights reserved.
//

import UIKit
import AVFoundation


class CameraViewController: UIViewController {
    
  /*  @IBAction func BackButtonTapped(sender: AnyObject) {
        
        let ProfilePage = self.storyboard?.instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
        let ProfilePageNav = UINavigationController(rootViewController: ProfilePage)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.rootViewController = ProfilePageNav
        
    }*/
    let captureSession = AVCaptureSession()
    
    var captureDevice : AVCaptureDevice?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        captureSession.sessionPreset = AVCaptureSession.Preset(rawValue: convertFromAVCaptureSessionPreset(AVCaptureSession.Preset.low))
        let devices = AVCaptureDevice.devices()
        
        for device in devices{
            // here we make sure the device can support video
            
            if ((device as AnyObject).hasMediaType(AVMediaType.video)){
                if ((device as AnyObject).position == AVCaptureDevice.Position.back){ // we check we got the back camera
                    captureDevice = device
                    
                    if captureDevice != nil {
                        beginSession()
                    }
            
                }
            }
                
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func beginSession(){
       // var err : NSError? = nil
        do {
            try captureSession.addInput(AVCaptureDeviceInput(device: captureDevice!))
        }
        catch _ {
            print("there was an error")
        }
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.view.layer.addSublayer(previewLayer)
        previewLayer.frame = self.view.layer.frame
        captureSession.startRunning()
    }
}
   

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVCaptureSessionPreset(_ input: AVCaptureSession.Preset) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVMediaType(_ input: AVMediaType) -> String {
	return input.rawValue
}
