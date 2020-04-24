//
//  EditorViewController.swift
//  Umojify
//
//  Created by Jacob Silverstein on 8/6/16.
//  Copyright © 2016 Umojify. All rights reserved.
//

import UIKit
import FaceGenerator

class EditorViewController: UIViewController {
    
    var dataArray = Array<Int>()
    var xArray = Array<Double>()
    var yArray = Array<Double>()
    var aspectRatio = Double()
    var emojiView = UIImageView()
    var emoji: EmojiView!
    var infoDict: Dictionary<String, String>!
    
    
    var editView: UIView!

    @IBOutlet var shareButton: UIButton!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var retakeButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()


        // Do any additional setup after loading the view.
        convertArray()
        if (UserDefaults.standard.object(forKey: "FullAccess") == nil) {
            checkForFullAccess()
        }
        
        //Set up main view
        let size = self.view.frame.width - 80
        emojiView = UIImageView.init(frame: CGRect(x: 40, y: 80, width: size, height: size))
        emojiView.backgroundColor = UIColor.white
        infoDict = ["ratio": String(aspectRatio), "size": String(Int(size))]
        emoji = createEmoji(xArray, arrayForY: yArray, infoDict: infoDict)

        self.view.addSubview(emojiView)
        emojiView.clipsToBounds = true
        emojiView.autoresizesSubviews = true
        emojiView.addSubview(emoji)
        
        self.view.backgroundColor = UIColor(red: 1.0/255.0, green: 86/255.0, blue: 154/255.0, alpha: 1.0)
        
        shareButton.backgroundColor = defaultButtonColor
        shareButton.layer.cornerRadius = 4
        editButton.backgroundColor = defaultButtonColor
        editButton.layer.cornerRadius = 4
        retakeButton.backgroundColor = defaultButtonColor
        retakeButton.layer.cornerRadius = 4
        
        self.navigationItem.hidesBackButton = true
        
        var image = UIImage(named: "homeIcon")
        
        image = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(homePressed(_:)))

        
        // Uncomment to display coordinates with indices as emojiImage
        /*
        for i in 0..<xArray.count {e
            let label = UILabel(frame: CGRectMake(0, 0, 9, 7))
            label.backgroundColor = UIColor.whiteColor()
            label.text = String(i)
            label.clipsToBounds = false
            label.font = UIFont(name: label.font.fontName, size: 6)!
            label.center = CGPoint(x: xArray[i] * Double(emojiView.bounds.size.width) * aspectRatio, y: yArray[i] * Double(emojiView.bounds.size.width))
            emojiView.addSubview(label)
        }
        */
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func convertArray() {
        //split into x and y
        for i in 0..<dataArray.count {
            if i % 2 == 0 {
                xArray.append(Double.init(dataArray[i]))
            } else {
                yArray.append(Double.init(dataArray[i]))
            }
            
        }
        
        //Convert to a decimal system where the view width and  
        let minX = xArray.min()! - 1
        let minY = yArray.min()! - 1
        let maxX = xArray.max()! - minX
        let maxY = yArray.max()! - minY
        
        aspectRatio = (yArray.max()! - yArray.min()!) / (xArray.max()! - xArray.min()!)

        for i in 0..<xArray.count {
            let xMod = (xArray[i] - minX)
            let yMod = (yArray[i] - minY)
            xArray[i] = xMod / maxX
            yArray[i] = yMod / maxY

        }
    }
    
    func checkForFullAccess() {
        
         let alertController = UIAlertController(title: "Enable Keyboards", message: "Add New Keyboard > Umojify", preferredStyle: .alert)
         
         // Create the actions
         let okAction = UIAlertAction(title: "Settings", style: UIAlertActionStyle.default) {
            UIAlertAction in
            if let settingsURL = URL(string: "prefs:root=General&path=Keyboard/KEYBOARDS") {
                UserDefaults.standard.set(1, forKey: "FullAccess")
                UserDefaults.standard.synchronize()
                UIApplication.shared.openURL(settingsURL)
            }
         }
         let cancelAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
            UserDefaults.standard.set(nil, forKey: "FullAccess")
            UserDefaults.standard.synchronize()
         }
         
         // Add the actions
         alertController.addAction(okAction)
         alertController.addAction(cancelAction)
         
         // Present the controller
         DispatchQueue.main.async(execute: {
         self.present(alertController, animated: true, completion: nil)
         })
    }
    
    func homePressed(_ sender: UIBarButtonItem) {
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func sharePressed(_ sender: AnyObject) {
        let myDefaults = UserDefaults.init(suiteName: "group.umojiDefaults")
        myDefaults!.set(xArray, forKey: "xArray")
        myDefaults!.set(yArray, forKey: "yArray")
        myDefaults!.set(infoDict, forKey: "infoDict")
        myDefaults!.synchronize()
        UIApplication.shared.openURL(URL(string: "sms:")!)
    }

    @IBAction func editPressed(_ sender: AnyObject) {
        buildEditView()
    }
    
    @IBAction func retakePressed(_ sender: AnyObject) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func updateHairColor(_ sender: UISlider) {
        let value = 1 - CGFloat(sender.value)
        let r = 73 + (value * 180)
        let g = 50 + (value * 166)
        let b = 42 + (value * 0)

        emoji.updateHairColor(UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1.0))
    }
    
    func updateSkinColor(_ sender: UISlider) {
        let value = 1 - CGFloat(sender.value)
        let r = 104 + (value * 150)
        let g = 72 + (value * 130)
        let b = 51 + (value * 140)
        
        emoji.updateSkinColor(UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1.0))
        emoji.updateNoseColor(UIColor(red: (r - 8)/255, green: (g - 8)/255, blue: (b - 8)/255, alpha: 1.0))

    }
    
    func buildEditView() {
        editView = UIView()
        self.view.addSubview(editView)
        editView.backgroundColor = UIColor(red: 11.0/255.0, green: 96.0/255.0, blue: 164.0/255.0, alpha: 1.0)
        editView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraint(editView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor))
        self.view.addConstraint(editView.leftAnchor.constraint(equalTo: self.view.leftAnchor))
        self.view.addConstraint(editView.rightAnchor.constraint(equalTo: self.view.rightAnchor))
        let heightConstraint = editView.heightAnchor.constraint(equalToConstant: 0)
        self.view.addConstraint(heightConstraint)
        
        let xButton = UIButton()
        xButton.setImage(UIImage(named: "xIcon"), for: UIControlState())
        xButton.addTarget(self, action: #selector(removeEditView), for: UIControlEvents.touchUpInside)
        editView.addSubview(xButton)
        xButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraint(xButton.topAnchor.constraint(equalTo: editView.topAnchor, constant: 8))
        self.view.addConstraint(xButton.rightAnchor.constraint(equalTo: editView.rightAnchor, constant: -8))
        self.view.addConstraint(xButton.widthAnchor.constraint(equalToConstant: 24))
        self.view.addConstraint(xButton.heightAnchor.constraint(equalToConstant: 24))
        
        let hairSlider = UISlider()
        hairSlider.addTarget(self, action: #selector(updateHairColor), for: UIControlEvents.valueChanged)
        editView.addSubview(hairSlider)
        hairSlider.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraint(hairSlider.topAnchor.constraint(equalTo: editView.topAnchor, constant: 50))
        self.view.addConstraint(hairSlider.leftAnchor.constraint(equalTo: editView.leftAnchor, constant: 16))
        self.view.addConstraint(hairSlider.rightAnchor.constraint(equalTo: editView.rightAnchor, constant: -16))
        self.view.addConstraint(hairSlider.heightAnchor.constraint(equalToConstant: 30))
        
        let skinSlider = UISlider()
        skinSlider.addTarget(self, action: #selector(updateSkinColor), for: UIControlEvents.valueChanged)
        editView.addSubview(skinSlider)
        skinSlider.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraint(skinSlider.topAnchor.constraint(equalTo: hairSlider.bottomAnchor, constant: 40))
        self.view.addConstraint(skinSlider.leftAnchor.constraint(equalTo: editView.leftAnchor, constant: 16))
        self.view.addConstraint(skinSlider.rightAnchor.constraint(equalTo: editView.rightAnchor, constant: -16))
        self.view.addConstraint(skinSlider.heightAnchor.constraint(equalToConstant: 30))
        
        editView.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            heightConstraint.constant = 240
            self.editView.layoutIfNeeded()
        })

    }
    
    func removeEditView() {
        UIView.animate(withDuration: 0.2, animations: {
            self.editView.center = CGPoint(x: self.editView.center.x, y: self.editView.center.y + self.editView.frame.size.height)
            }, completion: {
                (value: Bool) in
                self.editView.removeFromSuperview()
        })
    }
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
