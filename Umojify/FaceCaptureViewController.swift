//
//  FaceCaptureViewController.swift
//  Umojify
//
//  Created by Jacob Silverstein on 8/5/16.
//  Copyright © 2016 Umojify. All rights reserved.
//

import UIKit
import Darwin
import AVFoundation

class FaceCaptureViewController: UIViewController {
    let sessionHandler = SessionHandler()
    
    @IBOutlet weak var captureButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        sessionHandler.openSession()
        
        let layer = sessionHandler.layer
        
        let preview = UIView.init(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        layer.frame = preview.bounds
        preview.layer.addSublayer(layer)
        self.view.insertSubview(preview, at: 0)
        view.layoutIfNeeded()
        
        captureButton.layer.cornerRadius = 33
        captureButton.clipsToBounds = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(FaceCaptureViewController.updateButton(_:)),name:NSNotification.Name(rawValue: "update"), object: nil)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sessionHandler.startRunning()
    }
    
    func updateButton(_ notification: Notification){
        let hasFace = notification.object as! Int
        if hasFace == 1 {
            captureButton.isEnabled = true
            DispatchQueue.main.async(execute: {
                self.captureButton.setBackgroundImage(UIImage.init(named: "cameraOn"), for: UIControlState())
                self.captureButton.alpha = 0.90
            })
        } else {
            captureButton.isEnabled = false
            DispatchQueue.main.async(execute: {
            self.captureButton.setBackgroundImage(UIImage.init(named: "cameraOff"), for: UIControlState())
                self.captureButton.alpha = 0.8

            })        }
    }

    
    @IBAction func captureButtonPressed(_ sender: AnyObject) {
        let array = sessionHandler.getArray()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "EditorViewController") as! EditorViewController
        vc.dataArray = array
        
        sessionHandler.stopRunning()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
}



