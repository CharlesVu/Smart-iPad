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
    
    static var solarizedBase0: UIColor
    {
        return UIColor(fromRGB: 0x839496)
    }

    static var solarizedBase1: UIColor
    {
        return UIColor(fromRGB: 0x93a1a1)
    }

    static var solarizedBase2: UIColor
    {
        return UIColor(fromRGB: 0xeee8d5)
    }
    
    static var solarizedBase3: UIColor
    {
        return UIColor(fromRGB: 0xfdf6e3)
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

    static var solarizedYellow: UIColor
    {
        return UIColor(fromRGB: 0xb58900)
    }
}

struct ColorScheme
{
    let background: UIColor
    let alternativeBackground: UIColor
    let normalText: UIColor
    let alternativeText: UIColor
    let positiveText: UIColor
    let warningText: UIColor
    let errorText: UIColor
    let yellow: UIColor
}

extension ColorScheme
{
    static let solarizedDark = ColorScheme(background: UIColor.solarizedBase02,
                                           alternativeBackground:UIColor.solarizedBase03,
                                           normalText: UIColor.solarizedBase0,
                                           alternativeText: UIColor.solarizedBase00,
                                           positiveText: UIColor.solarizedGreen,
                                           warningText: UIColor.solarizedOrange,
                                           errorText: UIColor.solarizedRed,
                                           yellow: UIColor.solarizedYellow)
    
    static let solarizedLight = ColorScheme(background: UIColor.solarizedBase2,
                                            alternativeBackground:UIColor.solarizedBase3,
                                            normalText: UIColor.solarizedBase00,
                                            alternativeText: UIColor.solarizedBase0,
                                            positiveText: UIColor.solarizedGreen,
                                            warningText: UIColor.solarizedOrange,
                                            errorText: UIColor.solarizedRed,
                                            yellow: UIColor.solarizedYellow)
}
