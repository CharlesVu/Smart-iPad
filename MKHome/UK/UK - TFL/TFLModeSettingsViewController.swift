//
//  TFLModeSettingsViewController.swift
//  MKHome
//
//  Created by Charles Vu on 17/08/2019.
//  Copyright © 2019 charles. All rights reserved.
//

import Foundation
import UIKit

class TFLModeSettingsViewController: UITableViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TFL.Mode.allCases.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mode = TFL.Mode.allCases[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TFLModeSettings")!
        cell.textLabel?.text = mode.rawValue.capitalized

        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? TFLModeDetailSettingsViewControler,
            let cell = sender as? UITableViewCell {

            let selectedMode = TFL.Mode.allCases[tableView!.indexPath(for: cell)!.row]

            viewController.mode = selectedMode
        }
    }
}
