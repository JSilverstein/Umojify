//
//  FaceGeneratorController.swift
//  Umojify
//
//  Created by Jacob Silverstein on 9/10/16.
//  Copyright © 2016 Umojify. All rights reserved.
//

import UIKit

//Arrays of size 68 which coorespond to facial points
var xArray = [Double]()
var yArray = [Double]()
//A dictionary of attribute values. Refer to dictionary keys at bottom of page
var infoDictionary = Dictionary<String, String>()

//The angle of rotation of the face as captured by the camera
var faceAngle: Double! = 0

//The ratio used to determine extra forehead space in relation to the rest of the face
var foreheadCompensationRatio: Double! = 1.3

//The ratio of the height to width of the face
var headAspectRatio: Double! = 1

//The total size of the square containing the emoji image in pixels
var size: Double! = 400
var headSize: Double! = 400

//Hair Adjust Decimal, used to offset the image to allow for taller hair
let hairAdjust = 0.10

//A value used to determine the theme. Will change to var once more themes are added
let theme: Double = 1


///The main FaceGenerator function which is called from outside the framework.
public func createEmoji(_ arrayForX: Array<Double>, arrayForY: Array<Double>, infoDict: Dictionary<String, String>) -> (EmojiView) {
    
    //Set the the global framework variables to the values passed into the function
    infoDictionary = infoDict
    xArray = arrayForX
    yArray = arrayForY
    
    //Calculate the angle of the face from the left and right top profile points
    faceAngle = convertPointsToDegrees(0, 16)
    headAspectRatio = getDoubleFromDictWithKey("ratio") * foreheadCompensationRatio
    size = getDoubleFromDictWithKey("size")


    let emojiView = EmojiView(frame: CGRect(x: 0, y: 0, width: size, height: size))
    
    //Create the view
    if xArray.count == 68 {
        //drawFeaturesFromData()
    } else {
        //TODO: Add else
    }
    
    //Return the flattened emoji UIImage to the caller
    return emojiView
}

public func createFlattenedEmoji(_ arrayForX: Array<Double>, arrayForY: Array<Double>, infoDict: Dictionary<String, String>) -> (UIImage) {
    
    //Set the the global framework variables to the values passed into the function
    infoDictionary = infoDict
    xArray = arrayForX
    yArray = arrayForY
    
    //Calculate the angle of the face from the left and right top profile points
    faceAngle = convertPointsToDegrees(0, 16)
    headAspectRatio = getDoubleFromDictWithKey("ratio") * foreheadCompensationRatio
    size = getDoubleFromDictWithKey("size")
    
    
    let emojiView = EmojiView(frame: CGRect(x: 0, y: 0, width: size, height: size))
    
    //Create the view
    if xArray.count == 68 {
        //drawFeaturesFromData()
    } else {
        //TODO: Add else
    }
    
    //Return the flattened emoji UIImage to the caller
    return getFlattenedImageFromView(emojiView)
}



open class EmojiView: UIImageView {
    
    let head = Head()
    let mouth = Mouth()
    let nose = Nose()
    let eyes = Eyes()
    let hair = Hair()
    
    var headImage = UIImageView()
    var noseImage = UIImageView()
    var mouthImage = UIImageView()
    var rightEyeImage = UIImageView()
    var leftEyeImage = UIImageView()
    var hairImage = UIImageView()

    override public init(frame : CGRect) {
        super.init(frame : frame)
        
        headSize = size * (1 - hairAdjust)
        self.backgroundColor = UIColor.white
        drawHead(head)
        drawMouth(mouth)
        drawNose(nose)
        drawEyes(eyes)
        drawHair(hair)
    }
    
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    
    func drawHead(_ head: Head) {
        headImage = UIImageView.init(image: UIImage.init(named: "Head/1"))
        headImage.bounds.size = CGSize(width: headSize, height: headSize)
        headImage.center = CGPoint(x: size / 2, y: (size / 2) + (hairAdjust * size * 0.4))
        headImage.contentMode = .scaleAspectFit
        
        //Tint head color to match skin tone
        headImage.image = headImage.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        headImage.tintColor = UIColor.init(red: 187.0/255.0, green: 131.0/255.0, blue: 98.0/255.0, alpha: 1.0)
        
        self.addSubview(headImage)
    }
    
    func drawMouth(_ mouth: Mouth) {
        mouthImage = UIImageView.init(image: UIImage.init(named: "Mouth/\(getImageIndexFromMouth(mouth))"))
        mouthImage.frame.size = CGSize(width: mouth.width * headSize, height: mouth.height * headSize)
        mouthImage.center = CGPoint(x: headSize / 2, y: mouth.yLocation * headSize)
        mouthImage.contentMode = .scaleToFill
        headImage.addSubview(mouthImage)
        
    }
    
    func drawNose(_ nose: Nose) {
        noseImage = UIImageView.init(image: UIImage.init(named: "Nose/\(getImageIndexFromNose(nose))"))
        noseImage.frame.size = CGSize(width: nose.width * headSize, height: nose.height * headSize)
        noseImage.center = CGPoint(x: headSize / 2, y: (nose.yBottomLocation - (nose.height / 2)) * headSize)
        noseImage.contentMode = .scaleToFill
        headImage.addSubview(noseImage)
        
        noseImage.image = noseImage.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        noseImage.tintColor = UIColor.init(red: 167.0/255.0, green: 111.0/255.0, blue: 78.0/255.0, alpha: 1.0)
    }
    
    func drawEyes(_ eyes: Eyes) {
        leftEyeImage = UIImageView.init(image: UIImage.init(named: "Eyes/1"))
        leftEyeImage.frame.size = CGSize(width: eyes.width * headSize, height: eyes.height * headSize)
        leftEyeImage.center = CGPoint(x: eyes.xLocation * headSize, y: eyes.yLocation * headSize)
        leftEyeImage.contentMode = .scaleToFill
        headImage.addSubview(leftEyeImage)
        
        rightEyeImage = UIImageView.init(image: UIImage.init(named: "Eyes/1"))
        rightEyeImage.frame.size = CGSize(width: eyes.width * headSize, height: eyes.height * headSize)
        rightEyeImage.center = CGPoint(x: (1 - eyes.xLocation) * headSize, y: eyes.yLocation * headSize)
        rightEyeImage.contentMode = .scaleToFill
        headImage.addSubview(rightEyeImage)
    }
    
    func drawHair(_ hair: Hair) {
        hairImage = UIImageView.init(image: UIImage.init(named: "Hair/1"))
        hairImage.frame.size = CGSize(width: headSize / 1.28 * 1.1, height: headSize / 1.28)
        hairImage.center = CGPoint(x: headSize / 2 * 0.95, y: (headSize / 1.28) / 2.5)
        hairImage.contentMode = .scaleToFill
        headImage.addSubview(hairImage)
        
        hairImage.image = hairImage.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        hairImage.tintColor = UIColor.init(red: 253.0/255.0, green: 227/255.0, blue: 68/255.0, alpha: 1.0)
    }
    
    open func updateSkinColor(_ color: UIColor) {
        headImage.tintColor = color
    }
    
    open func updateHairColor(_ color: UIColor) {
        hairImage.tintColor = color
    }
    
    open func updateNoseColor(_ color: UIColor) {
        noseImage.tintColor = color
    }
}






//DICTIONARY KEYS
//ratio - head aspect ratio
//sex -





