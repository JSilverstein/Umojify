//
//  EditorView.swift
//  Umojify
//
//  Created by Jacob Silverstein on 9/14/16.
//  Copyright © 2016 Umojify. All rights reserved.
//

import UIKit


class EditorView: UIView {

    @IBOutlet var hairSlider: UISlider!
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "EditorView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    
    @IBAction func hairSliderChanged(_ sender: AnyObject) {
        
    }

    @IBAction func exitButtonPressed(_ sender: AnyObject) {
        self.removeFromSuperview()
    }
}
