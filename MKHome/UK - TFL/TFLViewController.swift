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
import Persistance

// Train Only
class TFLViewController: UIViewController {
    var statusSet: Set<Line> = []
    var orderedStatuses = [Line]()
    let interactor = TFL.TFLIntetactor()
    @IBOutlet weak var tableView: UITableView?

    override func viewDidLoad() {
        reloadStatus()
        tableView?.rowHeight = UITableView.automaticDimension
        tableView?.estimatedRowHeight = 150

        Timer.every(1.minute) {
            self.reloadDisplay()
        }
    }

    func reloadStatus() {
        TFL.Mode.allCases.forEach { mode in
            interactor.getLineStatus(mode: mode) { (lines) in
                lines.forEach { self.statusSet.insert($0) }
                self.orderedStatuses = self.orderStatuses()

                self.reloadDisplay()
            }
        }
    }

    func reloadDisplay() {
        tableView?.reloadData()
    }

    func orderStatuses() -> [Line] {
        return Array(statusSet).sorted { (line1, line2) -> Bool in

            let firstLineStatus = line1.lineStatuses!.compactMap {$0}.sorted(by: { (status1, status2) -> Bool in
                return status1.statusSeverity! < status2.statusSeverity!
            }).first!
            let secondLineStatus = line2.lineStatuses!.compactMap {$0}.sorted(by: { (status1, status2) -> Bool in
                return status1.statusSeverity! < status2.statusSeverity!
            }).first!

            if firstLineStatus.statusSeverity! == secondLineStatus.statusSeverity! {
                return line1._id! < line2._id!
            }
            return firstLineStatus.statusSeverity! < secondLineStatus.statusSeverity!
        }
    }
}

extension TFLViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statusSet.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentLine = orderedStatuses[indexPath.row]
        let lineID = currentLine._id!
        let allStatus = currentLine.lineStatuses!.compactMap {$0}.sorted(by: { (status1, status2) -> Bool in
            return status1.statusSeverity! < status2.statusSeverity!
        })

        let firstStatus = allStatus.first!
        let cell: TFLCell

        if allStatus.filter({$0.statusSeverity != 10}).count > 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "TFLCellFucked") as! TFLCell
            cell.additionalInformationLabel?.text = allStatus.compactMap { $0.reason }.joined(separator: "\n\n")

        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "TFLCellNormal") as! TFLCell
        }

        cell.lineBackgroundView.backgroundColor = UIColor(named: lineID)
        cell.lineNameLabel.textColor = UIColor(named: "\(lineID)-text")
        cell.serviceStatusLabel.textColor = UIColor(named: "\(lineID)-text")
        cell.lineNameLabel.text = currentLine.name
        cell.serviceStatusLabel?.text = Persistance.shared.statusDescription(for: currentLine.modeName!,
                                                                             level: firstStatus.statusSeverity!)?.name

        return cell
    }
}
