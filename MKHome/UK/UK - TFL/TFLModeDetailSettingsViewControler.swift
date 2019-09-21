//
//  TFLModeDetailSettingsViewControler.swift
//  MKHome
//
//  Created by Charles Vu on 17/08/2019.
//  Copyright © 2019 charles. All rights reserved.
//

import Foundation
import UIKit
import Persistance

class TFLModeDetailSettingsViewControler: UIViewController {
    var mode: TFL.Mode = .tube
}

extension TFLModeDetailSettingsViewControler: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        let allModes = Persistance.shared.allTFLModes()
        let selectedMode = allModes.first { $0.name == mode.rawValue }

        return selectedMode!.lines.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let allModes = Persistance.shared.allTFLModes()
        let selectedMode = allModes.first { $0.name == mode.rawValue }!
        let line = selectedMode.lines[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: "TFLModeDetailSettings")!
        cell.textLabel?.text = line.name
        if Persistance.shared.isLineActivated(line) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
}

extension TFLModeDetailSettingsViewControler: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let allModes = Persistance.shared.allTFLModes()
        let selectedMode = allModes.first { $0.name == mode.rawValue }!
        let line = selectedMode.lines[indexPath.row]
        if Persistance.shared.isLineActivated(line) {
            Persistance.shared.disableLine(line)
        } else {
            Persistance.shared.activateLine(line)
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
