//
//  Head.swift
//  Umojify
//
//  Created by Jacob Silverstein on 9/7/16.
//  Copyright © 2016 Umojify. All rights reserved.
//

import Foundation

struct Head {
    //A value which determines how tall the face it vs the width
    var aspectRatio: Double!
    //A value which states width of the cheeks compared to top of head. Positive is fatter
    var profileAngle: Double!
    
    var height: Double!
    
    
    init() {
        self.aspectRatio = headAspectRatio
        self.profileAngle = generateProfileAngle()
    }
    
    func generateProfileAngle() -> Double {
        let angle = convertPointsToDegrees(0, 3)
        return angle
    }
    
}

let headArray =
[
    [ratioFromValues(388, 540), 85]
]