//
//  KeyboardViewController.swift
//  Keyboard
//
//  Created by Jacob Silverstein on 8/9/16.
//  Copyright © 2016 Umojify. All rights reserved.
//


import UIKit
import FaceGenerator

class KeyboardViewController: UIInputViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var nextKeyboardButton: UIButton!
    var heightConstraint: NSLayoutConstraint!
    var nextKeyboardButtonLeftSideConstraint: NSLayoutConstraint!
    var collectionView: UICollectionView!
    let customHeight:CGFloat = 320
    
    var xArray = [Double]()
    var yArray = [Double]()
    var infoDict = Dictionary<String, String>()
    
    
    
    override func updateViewConstraints()
    {
        super.updateViewConstraints()
        
        // Add custom view sizing constraints here
        if (view.frame.size.width == 0 || view.frame.size.height == 0) {
            return
        }
        
        setUpHeightConstraint()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let myDefaults = UserDefaults.init(suiteName: "group.umojiDefaults")
        if (myDefaults!.object(forKey: "xArray") != nil) {
            xArray = myDefaults!.object(forKey: "xArray") as! [Double]
            yArray = myDefaults!.object(forKey: "yArray") as! [Double]
            infoDict = myDefaults!.object(forKey: "infoDict") as! Dictionary<String, String>
        } else {
            print("No shared user defaults")
        }
        
        nextKeyboardButton = UIButton(type: .system)
        let attributedTitle = NSAttributedString(string: "ABC", attributes: [NSForegroundColorAttributeName: UIColor.white])
        nextKeyboardButton.setAttributedTitle(attributedTitle, for: UIControlState())
        nextKeyboardButton.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        nextKeyboardButton.titleLabel?.tintColor = UIColor.white
        nextKeyboardButton.sizeToFit()
        nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        nextKeyboardButton.addTarget(
            self,
            action: #selector(advanceToNextInputMode),
            for: .touchUpInside)
        view.addSubview(nextKeyboardButton)
        view.backgroundColor = UIColor(red: 142.0/255.0, green: 80.0/255.0, blue: 139.0/255.0, alpha: 1.0)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)

        
        // Set up constraints for next keyboard button in view did appear
        if nextKeyboardButtonLeftSideConstraint == nil {
            nextKeyboardButtonLeftSideConstraint = NSLayoutConstraint(
                item: nextKeyboardButton,
                attribute: .left,
                relatedBy: .equal,
                toItem: view,
                attribute: .left,
                multiplier: 1.0,
                constant: 8.0)
            let nextKeyboardButtonBottomConstraint = NSLayoutConstraint(
                item: nextKeyboardButton,
                attribute: .top,
                relatedBy: .equal,
                toItem: view,
                attribute: .top,
                multiplier: 1.0,
                constant: 0.0)
            view.addConstraints([
                nextKeyboardButtonLeftSideConstraint,
                nextKeyboardButtonBottomConstraint])
        }
        
        setUpCollectionView()
        
    }
    
    func setUpCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 10, right: 20)
        layout.itemSize = CGSize(width: 160, height: 160)
        
        print("HI", self.inputView?.bounds)
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 40, width: self.inputView!.bounds.size.width, height: customHeight - 40), collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = UIColor.white
        collectionView.bounces = true
        collectionView.isScrollEnabled = true
        self.view.addSubview(collectionView)
        
    }
    
    // MARK: Set up height constraint
    func setUpHeightConstraint()
    {
        if heightConstraint == nil {
            heightConstraint = NSLayoutConstraint(item: view,
                                                  attribute: .height,
                                                  relatedBy: .equal,
                                                  toItem: nil,
                                                  attribute: .notAnAttribute,
                                                  multiplier: 1,
                                                  constant: customHeight)
            heightConstraint.priority = UILayoutPriority(UILayoutPriorityRequired)
            
            view.addConstraint(heightConstraint)
        }
        else {
            heightConstraint.constant = customHeight
        }
    }
    
    // MARK: Text related
    override func textWillChange(_ textInput: UITextInput?)
    {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?)
    {
        // The app has just changed the document's contents, the document context has been updated.
        
        var textColor: UIColor
        let proxy = textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
            textColor = UIColor.white
        }
        else {
            textColor = UIColor.black
        }
        nextKeyboardButton.setTitleColor(textColor, for: UIControlState())
    }

    // MARK: UICollectionViewCell DataSource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = UIColor.gray
        let imageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 160, height: 160))
        cell.addSubview(imageView)
        imageView.image =  createFlattenedEmoji(xArray, arrayForY: yArray, infoDict: infoDict)
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(KeyboardViewController.imageTapped(_:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        return cell
    }
    
    func imageTapped(_ tap: UITapGestureRecognizer)
    {
        infoDict.updateValue("100", forKey: "size")
        let data = UIImagePNGRepresentation(createFlattenedEmoji(xArray, arrayForY: yArray, infoDict: infoDict))
        UIPasteboard.general.setData(data!, forPasteboardType: "public.png")
        let messageView = copyLabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: customHeight))
        messageView.backgroundColor = UIColor(red: 142.0/255.0, green: 80.0/255.0, blue: 139.0/255.0, alpha: 1.0)
        messageView.text = "Umoji copied, tap the message box to PASTE"
        messageView.font = UIFont(name: "HelveticaNeue-Bold", size: CGFloat(24))
        messageView.textColor = UIColor.white
        messageView.textAlignment = .center
        messageView.alpha = 1
        messageView.numberOfLines = 0
        self.view.addSubview(messageView)
        
        collectionView.isUserInteractionEnabled = false
        UIView.animate(withDuration: 1.5, delay: 0.5, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
            messageView.alpha = 0
            }, completion: { _ in
                messageView.removeFromSuperview()
                self.collectionView.isUserInteractionEnabled = true


        })
    }

    class copyLabel: UILabel {
        let topInset = CGFloat(12.0), bottomInset = CGFloat(12.0), leftInset = CGFloat(20.0), rightInset = CGFloat(20.0)
        
        override func drawText(in rect: CGRect) {
            let insets: UIEdgeInsets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
            super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
        }
    }
}

