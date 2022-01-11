//
//  UIColorExt.swift
//  PullUp
//
//  Created by Vikram Singh on 1/10/22.
//

import Foundation
import UIKit
extension UIColor {
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0

        getRed(&r, green: &g, blue: &b, alpha: &a)

        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0

        return NSString(format:"#%06x", rgb) as String
    }

    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    //generates a random color and returns the hexidecimal value.
    static func generateRandomHexColor() -> String{
        let randomRed = Int.random(in: 0..<256)
        let randomGreen = Int.random(in: 0..<256)
        let randomBlue = Int.random(in: 0..<256)
        
        let courseColor = UIColor(red: randomRed, green: randomGreen, blue: randomBlue)
        return courseColor.toHexString()
    }
}
