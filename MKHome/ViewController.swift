//
//  ViewController.swift
//  MKHome
//
//  Created by charles on 16/11/2016.
//  Copyright © 2016 charles. All rights reserved.
//

import UIKit
import ForecastIO
import CoreLocation
import HomeKit
import HuxleySwift
import Persistance

class RootViewController: UIViewController {
    // Weather Stuff
    @IBOutlet weak var currentTime: UILabel?
    @IBOutlet weak var currentDate: UILabel?

    let dateCellFormatter = DateFormatter()
    let currentDayCellFormatter = DateFormatter()

    // Train Stuff
    @IBOutlet weak var lightView: LightView?

    // Home Stuff    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        dateCellFormatter.setLocalizedDateFormatFromTemplate("HH:mm")
        currentDayCellFormatter.setLocalizedDateFormatFromTemplate("dd MMMM YYYY")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        refreshTime()
        
        Timer.every(10.second) {
            self.refreshTime()
        }

    }

    func refreshTime() {
        currentTime?.text = dateCellFormatter.string(from: Date())
        currentDate?.text = currentDayCellFormatter.string(from: Date())
    }
}
