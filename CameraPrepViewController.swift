//
//  CameraPrepViewController.swift
//  Umojify
//
//  Created by Jacob Silverstein on 8/20/16.
//
//  CameraPrepViewController.swift
//  Umojify
//
//  Created by Jacob Silverstein on 8/16/16.
//  Copyright © 2016 Umojify. All rights reserved.
//

import UIKit
import AVFoundation

class CameraPrepViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var maleImage: UIImageView!
    @IBOutlet var femaleImage: UIImageView!
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var uploadButton: UIButton!
    @IBOutlet var continueButton: UIButton!
    @IBOutlet var femaleButton: UIButton!
    @IBOutlet var maleButton: UIButton!
    var activityIndicator = UIActivityIndicatorView()
    
    
    var gender = 2
    var name = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup continue button
        continueButton.backgroundColor = defaultButtonColor
        continueButton.layer.cornerRadius = 4
        
        uploadButton.backgroundColor = defaultButtonColor
        uploadButton.layer.cornerRadius = 4
        
        
        maleButton.layer.cornerRadius = 6
        femaleButton.layer.cornerRadius = 6


        
        /*
        maleButton.backgroundColor = UIColor(red: 41.0/255.0, green: 182.0/255.0, blue: 246.0/255.0, alpha: 1.0)
        maleButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        femaleButton.backgroundColor = UIColor(red: 255.0/255.0, green: 105.0/255.0, blue: 180.0/255.0, alpha: 1.0)
        femaleButton.layer.borderColor = UIColor.whiteColor().CGColor
        */
        
        self.navigationController!.navigationBar.tintColor = UIColor.white
        
        headerLabel.text = "Welcome " + name
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
        activityIndicator.frame.size = CGSize.init(width: 120, height: 120)
        activityIndicator.transform = CGAffineTransform(scaleX: 3.0, y: 3.0);
        activityIndicator.center = self.view.center
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.stopAnimating()
        self.view.addSubview(activityIndicator)
        
        checkCameraIsEnabled()
        updateGender()
        
    }
    
    func checkCameraIsEnabled() {
        if AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) ==  AVAuthorizationStatus.authorized
        {
            // Already Authorized
            print("Camera is Enabled")

        } else {
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (granted :Bool) -> Void in
                if granted == true
                {
                    // User granted, update cheese button

                } else {
                    // User Rejected
                    let alertController = UIAlertController(title: "Enable Camera", message: "Allow Camera Access", preferredStyle: .alert)

                    // Create the actions
                    let okAction = UIAlertAction(title: "Settings", style: UIAlertActionStyle.default) {
                        UIAlertAction in
                        UIApplication.shared.openURL(URL(string:UIApplicationOpenSettingsURLString)!)
                    }
                    let cancelAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.cancel) {
                        UIAlertAction in
                        NSLog("Cancel Pressed")
                    }

                    // Add the actions
                    alertController.addAction(okAction)
                    alertController.addAction(cancelAction)

                    // Present the controller
                    DispatchQueue.main.async(execute: {
                        self.present(alertController, animated: true, completion: nil)
                    })
                    
                }
            });
        }
    }
    @IBAction func malePressed(_ sender: AnyObject) {
        gender = 0
        updateGender()
    }
    
    @IBAction func femalePressed(_ sender: AnyObject) {
        gender = 1
        updateGender()
    }
    
    func updateGender() {
        if gender == 0 {
            maleButton.isEnabled = false
            femaleButton.isEnabled = true
            maleButton.backgroundColor = UIColor.white
            femaleButton.backgroundColor = UIColor.clear
            let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            animation.duration = 0.6
            animation.values = [0, 0.12, -0.12, 0.1, -0.1, 0.05, -0.05, 0]
            maleImage.layer.add(animation, forKey: "shake")
        
            continueButton.setTitle("Take Selfie!", for: UIControlState())
            continueButton.backgroundColor = defaultButtonColor
            continueButton.isEnabled = true
            
            uploadButton.isHidden = false
            
        } else if gender == 1 {
            femaleButton.isEnabled = false
            maleButton.isEnabled = true
            femaleButton.backgroundColor = UIColor.white
            maleButton.backgroundColor = UIColor.clear
            let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            animation.duration = 0.6
            animation.values = [0, -0.12, 0.12, -0.1, 0.1, -0.05, 0.05, 0]
            //animation.values = [0, M_PI * 2]
            femaleImage.layer.add(animation, forKey: "shake")
            
            continueButton.setTitle("Take Selfie!", for: UIControlState())
            continueButton.backgroundColor = defaultButtonColor
            continueButton.isEnabled = true
        
            uploadButton.isHidden = false

            
        } else if gender == 2 {
            femaleButton.backgroundColor = UIColor.clear
            maleButton.backgroundColor = UIColor.clear
            continueButton.setTitle("Select Gender", for: UIControlState())
            continueButton.backgroundColor = UIColor.red
            continueButton.isEnabled = false
            continueButton.layer.borderWidth = 0
            
            uploadButton.isHidden = true

        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.isUserInteractionEnabled = true
        activityIndicator.stopAnimating()
    }
    
    @IBAction func continueButtonPressed(_ sender: AnyObject) {
        self.view.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
        let segueQueue:DispatchQueue = DispatchQueue(label: "segue", attributes: [])
        segueQueue.async(execute: {
            Thread.sleep(forTimeInterval: 0.1)
            DispatchQueue.main.async(execute: {
                self.performSegue(withIdentifier: "toCamera", sender: nil)
            })
        })

        
    }
    @IBAction func uploadButtonPressed(_ sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            dismiss(animated: false, completion: nil)
            
        }
        
        
        dismiss(animated: false, completion: nil)
    }
    
    func isValidFaceImage() {
        
        
    }
}
