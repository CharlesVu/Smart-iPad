//
//  LightCell.swift
//  MKHome
//
//  Created by Charles Vu on 23/12/2016.
//  Copyright © 2016 charles. All rights reserved.
//

import Foundation
import HomeKit
import UIKit
import ForecastIO

class LightCell: UICollectionViewCell {
    @IBOutlet weak var roomName: UILabel?
    @IBOutlet weak var lightLevel: SKYIconView?

    var colorScheme = UserSettings.sharedInstance.colorScheme.scheme {
        didSet {
            reloadData()
        }
    }

    fileprivate var characteristics: [HMCharacteristic] = []
    fileprivate var name: String = ""

    func setProperties(name: String, characteristics: [HMCharacteristic]) {
        self.characteristics = characteristics
        self.name = name
        reloadData()
    }

    func reloadData() {
        roomName?.text = name
        backgroundColor = UIColor.clear
        roomName?.textColor = colorScheme.normalText
        lightLevel?.setType = .clearNight
        lightLevel?.tintColor = colorScheme.normalText
        lightLevel?.play()

        for characteristic in characteristics {
            if let reachable = characteristic.service?.accessory?.isReachable {
                characteristic.readValue { (error) in
                    if error == nil {
                        if let value = characteristic.value as? Bool, value, reachable {
                            self.lightLevel?.setType = .clearDay
                            self.lightLevel?.tintColor = self.colorScheme.yellow

                            self.lightLevel?.play()
                        }
                    }
                }
            }
        }

    }
}
