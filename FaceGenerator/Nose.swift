//
//  Nose.swift
//  Umojify
//
//  Created by Jacob Silverstein on 9/12/16.
//  Copyright © 2016 Umojify. All rights reserved.
//

import Foundation

struct Nose {
    var height: Double = 0.2
    var width: Double = 0.3
    var aspectRatio: Double = 1
    var yBottomLocation: Double = 0
    var yLocation: Double = 0

    
    init() {
        setBottomLocation()
        setCenterLocation()
        setHeightWidthRatio()
    }
    
    mutating func setBottomLocation() {
        let y = yArray[33]
        yBottomLocation = compensateForY(y)
    }
    
    mutating func setCenterLocation() {
        let y = (yArray[33] + yArray[28]) / 2
        yLocation = compensateForY(y)
    }
    
    mutating func setHeightWidthRatio() {
        width = distanceBetweenPoints(31, 35) / headAspectRatio
        height = distanceBetweenPoints(28, 33) / foreheadCompensationRatio
        aspectRatio = ratioFromValues(width, height)

        
    }
    
    //Hardcoded values for noses stored in image assets
    //KEY: Index(Int), Theme(Bool), Ratio(Width, Height)
    let noseArray =
        [   [1, 1, ratioFromValues(380, 556)],
            [2, 1, ratioFromValues(380, 556)],
            [3, 1, ratioFromValues(380, 556)],
            [4, 1, ratioFromValues(338, 556)],
            [5, 1, ratioFromValues(349, 556)],
            [6, 1, ratioFromValues(349, 556)],
            [7, 1, ratioFromValues(328, 556)],
            [8, 1, ratioFromValues(314, 556)],
            [9, 1, ratioFromValues(266, 556)],
    ]
    
}

func getImageIndexFromNose(_ nose: Nose) -> Int {
    var checkArray = Array(repeating: 1.0, count: nose.noseArray.count)
    
    for (index, subArray) in nose.noseArray.enumerated() {
        
        //Select theme
        if subArray[1] != theme {
            checkArray[index] = 0
        }

        //Check Ratio
        checkArray[index] = checkArray[index] * (1 - abs(nose.aspectRatio - subArray[2]))
        
    }
    var i = 1
    var max = 0.0
    for (index, value) in checkArray.enumerated() {
        if value > max {
            max = value
            i = index + 1
        }
        
    }
    return i
    
}
