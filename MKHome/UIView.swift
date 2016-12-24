//
//  UIView.swift
//  MKHome
//
//  Created by Charles Vu on 24/12/2016.
//  Copyright © 2016 charles. All rights reserved.
//

import Foundation

extension UIView
{
    func fadeTransition(duration:CFTimeInterval)
    {
        let animation:CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = kCATransitionFromTop
        animation.duration = duration
        self.layer.add(animation, forKey: kCATransitionFromTop)
    }

    func pushTransition(duration:CFTimeInterval)
    {
        let animation:CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = kCATransitionPush
        animation.duration = duration
        self.layer.add(animation, forKey: kCATransitionPush)
    }
}
