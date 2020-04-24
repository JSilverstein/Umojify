//
//  Brows.swift
//  Umojify
//
//  Created by Jacob Silverstein on 9/29/16.
//  Copyright © 2016 Umojify. All rights reserved.
//

import UIKit

struct Brows {
    var width: Double = 0.8
    var height: Double = 0.1
    
    var yLocation: Double = 0.25
    var xLocation: Double = 0.3
    
    init() {
        setCenterLocation()
        setWidthHeight()
    }
    
    mutating func setCenterLocation() {
        let y = (yArray[20] + yArray[17]) / 2
        yLocation = compensateForY(y)
        
        let x = (((xArray[17] + xArray[21]) / 2))
        //Shift x location inwards with aspect ratio
        let compX = x * (1 + ((0.5 - x) * headAspectRatio))
        xLocation = compX
    }
    
    mutating func setWidthHeight() {
        width = distanceBetweenPoints(17, 21) / headAspectRatio
        height = ((distanceBetweenPoints(20, 17) + distanceBetweenPoints(23, 26)) / 2) / foreheadCompensationRatio
        //height = width * 0.187
    }
}
