//
//  Eyes.swift
//  Umojify
//
//  Created by Jacob Silverstein on 9/14/16.
//  Copyright © 2016 Umojify. All rights reserved.
//

import Foundation

struct Eyes {
    var width: Double = 0.8
    var height: Double = 0.1
    
    var yLocation: Double = 0.3
    var xLocation: Double = 0.3
    
    init() {
        setCenterLocation()
        setWidthHeight()
    }
    
    mutating func setCenterLocation() {
        let y = (yArray[39] + yArray[42]) / 2
        yLocation = compensateForY(y)
        
        let x = (((xArray[36] + xArray[39]) / 2))
        //Shift x location inwards with aspect ratio
        let compX = x * (1 + ((0.5 - x) * headAspectRatio))
        xLocation = compX
    }
    
    mutating func setWidthHeight() {
        width = distanceBetweenPoints(36, 39) / headAspectRatio
        height = ((distanceBetweenPoints(38, 40) + distanceBetweenPoints(43, 47)) / 2) / foreheadCompensationRatio
        //height = width * 0.187
    }
}
