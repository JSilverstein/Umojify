//
//  GlobalFunctions.swift
//  Umojify
//
//  Created by Jacob Silverstein on 9/10/16.
//  Copyright © 2016 Umojify. All rights reserved.
//

import UIKit

//Used to determine feature angles, includes compensation for face angle
func convertPointsToDegrees(_ p1: Int, _ p2: Int) -> (Double) {
    let angleRadians = (yArray[p1] - yArray[p2]) / (xArray[p1] - xArray[p2])
    let angleDegrees = atan(angleRadians) * 180 / M_PI
    
    if faceAngle != 0 {
        return angleDegrees - faceAngle
    } else {
        return angleDegrees
    }
}


func getFlattenedImageFromView(_ imageView: UIView) -> UIImage {
    var image = UIImage()
    UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, imageView.isOpaque, 0.0)
    imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
    image = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext();
    //return image
    return image
}

func getDoubleFromDictWithKey(_ key: String) -> Double {
    if infoDictionary[key] != nil {
        let dicString = infoDictionary[key]!
        
        print("\(key) is \(dicString)")
        return Double(dicString)!
    } else {
        print("\(key) doesn't exist")
        return 0
    }
}

func compensateForY(_ y: Double) -> Double {
    //adding extra headroom because of mapping only going to brows based on constant
    let CONSTANT = 2 - foreheadCompensationRatio
    let compensation = 1 - ((1 - y) * (CONSTANT))
    return compensation
}

func ratioFromValues(_ width: Double, _ height: Double) -> Double {
    let ratio = (height / width)
    return ratio
}

func distanceBetweenPoints(_ p1: Int, _ p2: Int) -> Double {
    let xDist = (xArray[p2] - xArray[p1])
    let yDist = (yArray[p2] - yArray[p1])
    return sqrt((xDist * xDist) + (yDist * yDist));
}
