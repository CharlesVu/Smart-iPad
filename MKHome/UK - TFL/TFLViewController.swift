//
//  TFLViewController.swift
//  MKHome
//
//  Created by Charles Vu on 06/06/2019.
//  Copyright © 2019 charles. All rights reserved.
//

import Foundation
import UIKit
import TFLApiModels

// Train Only
class TFLViewController: UIViewController {
    var statusSet: Set<Line> = []
    let interactor = TFL.TFLIntetactor()

    override func viewDidLoad() {
        reloadStatus()
    }

    func reloadStatus() {
        TFL.Mode.allCases.forEach { mode in
            interactor.getLineStatus(mode: mode) { (lines) in
                lines.forEach { self.statusSet.insert($0) }
            }
        }
    }

    func reloadDisplay() {
        
    }
}
