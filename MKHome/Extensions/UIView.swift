//
//  UIView.swift
//  MKHome
//
//  Created by Charles Vu on 24/12/2016.
//  Copyright © 2016 charles. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func fadeTransition(duration: CFTimeInterval) {
        let animation: CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = .moveIn
        animation.duration = duration
        self.layer.add(animation, forKey: CATransitionSubtype.fromTop.rawValue)
    }

    func pushTransition(duration: CFTimeInterval) {
        let animation: CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = .push
        animation.duration = duration
        self.layer.add(animation, forKey: CATransitionType.push.rawValue)
    }
}
