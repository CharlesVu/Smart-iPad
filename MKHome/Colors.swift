//
//  Colors.swift
//  MKHome
//
//  Created by charles on 16/11/2016.
//  Copyright © 2016 charles. All rights reserved.
//

import Foundation
import UIKit
/*
 $base0:     #839496;

 $base2:     #eee8d5;
 $base3:     #fdf6e3;
 $yellow:    #b58900;
 $magenta:   #d33682;
 $violet:    #6c71c4;
 $blue:      #268bd2;
 $cyan:      #2aa198;
 */
extension UIColor
{
    convenience init(fromRGB rgbValue: UInt)
    {
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    static var solarizedBase03: UIColor
    {
        return UIColor(fromRGB: 0x002b36)
    }
    
    static var solarizedBase02: UIColor
    {
        return UIColor(fromRGB: 0x073642)
    }
    
    static var solarizedBase01: UIColor
    {
        return UIColor(fromRGB: 0x586e75)
    }
    
    static var solarizedBase00: UIColor
    {
        return UIColor(fromRGB: 0x657b83)
    }
    
    static var solarizedBase1: UIColor
    {
        return UIColor(fromRGB: 0x93a1a1)
    }
    
    static var solarizedRed: UIColor
    {
        return UIColor(fromRGB: 0xdc322f)
    }
    
    static var solarizedOrange: UIColor
    {
        return UIColor(fromRGB: 0xcb4b16)
    }
    
    static var solarizedGreen: UIColor
    {
        return UIColor(fromRGB: 0x859900)
    }
}
