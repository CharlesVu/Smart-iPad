//
//  ThemableViewController.swift
//  MKHome
//
//  Created by charles on 06/01/2017.
//  Copyright © 2017 charles. All rights reserved.
//

import Foundation
import UIKit

open class ThemableViewController: UIViewController {
    fileprivate var observer: NSObjectProtocol?

    public var colorScheme = UserSettings.sharedInstance.colorScheme.scheme

    open override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshColors()

        observer = NotificationCenter.default.addObserver(forName: NSNotification.Name("Settings.ColorChanged"),
                                                          object: nil,
                                                          queue: OperationQueue.main) { (notification) in
            if let colorScheme = notification.userInfo?["colorScheme"] as? ColorScheme {
                self.colorScheme = colorScheme
                self.refreshColors()
            }
        }
    }

    deinit {
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }

    open func refreshColors() {

    }

}
