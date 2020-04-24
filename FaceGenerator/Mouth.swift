//
//  Mouth.swift
//  Umojify
//
//  Created by Jacob Silverstein on 9/10/16.
//  Copyright © 2016 Umojify. All rights reserved.
//

import Foundation

struct Mouth {
    var smile: Double = 1 //Bool
    var height: Double = 0.2
    var width: Double = 0.3
    var yLocation: Double = 0
    var aspectRatio: Double = 1
    
    
    init() {
        checkForSmile()
        setCenterLocation()
        setHeightWidthRatio()
    }
    
    
    
    mutating func checkForSmile(){
        let c1 = convertPointsToDegrees(48, 60)
        let c2 = convertPointsToDegrees(54, 64)
        if c1 - c2 >= 0 {
            smile = 1
        } else {
            smile = 0
        }
    }
    
    mutating func setCenterLocation() {
        let y = (yArray[57] + yArray[51]) / 2
        yLocation = compensateForY(y)
    }
    
    mutating func setHeightWidthRatio() {
        width = distanceBetweenPoints(48, 54) / headAspectRatio
        height = distanceBetweenPoints(51, 57) / foreheadCompensationRatio
        aspectRatio = ratioFromValues(width, height)
        
    }
    
    //Hardcoded values for mouths stored in image assets
    //KEY: Index(Int), Theme(Bool), Smile(Bool), Ratio(Width, Height)
    let mouthArray =
        [   [1, 1, 1, ratioFromValues(556, 162)],
            [2, 1, 1, ratioFromValues(556, 138)],
            [3, 1, 1, ratioFromValues(556, 116)],
            [4, 1, 1, ratioFromValues(556, 92)],
            [5, 1, 1, ratioFromValues(556, 54)],
            [6, 1, 0, ratioFromValues(427, 554)],
            [7, 1, 0, ratioFromValues(550, 550)],
            [8, 1, 0, ratioFromValues(550, 385)],
            [9, 1, 0, ratioFromValues(550, 276)],
            [10, 1, 0, ratioFromValues(550, 166)]
        ]
    
}

func getImageIndexFromMouth(_ mouth: Mouth) -> Int {
    var checkArray = Array(repeating: 1.0, count: mouth.mouthArray.count)
    
    for (index, subArray) in mouth.mouthArray.enumerated() {
        
        //Select theme
        if subArray[1] != theme {
            checkArray[index] = 0
        }
        
        //Check smile equals
        if mouth.smile != subArray[2] {
            checkArray[index] = 0
        }
        
        //Check Ratio
        checkArray[index] = checkArray[index] * (1 - abs(mouth.aspectRatio - subArray[3]))
        
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











