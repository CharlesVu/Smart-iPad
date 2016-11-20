//
//  SettingsViewController.swift
//  MKHome
//
//  Created by charles on 19/11/2016.
//  Copyright © 2016 charles. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController
{
    fileprivate var colorScheme = ColorScheme.solarizedLight
    let userSettings = UserSettings.sharedInstance
    
    @IBOutlet var trainJourneyTableView: UITableView?
    
    override func viewDidLoad()
    {
        view.backgroundColor = colorScheme.alternativeBackground
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.trainJourneyTableView?.reloadData()
    }
    
    @IBAction func onButtonClicked(button: UIButton)
    {
        UserSettings.sharedInstance.addJourney(Journey(originCRS: "MKC", destinationCRS: "EUS"))
    }

    @IBAction func onCloseClicked(button: UIButton)
    {
        self.dismiss(animated: true)
    }
}

extension SettingsViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return userSettings.getJourneys().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let journey = userSettings.getJourneys()[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "journeyCell")!
        
        cell.textLabel?.text = "\(journey.originCRS) to \(journey.destinationCRS)"
        cell.textLabel?.textColor = colorScheme.normalText
        cell.backgroundColor = colorScheme.alternativeBackground
        
        if UIDevice.current.userInterfaceIdiom == .pad
        {
            cell.preservesSuperviewLayoutMargins = false
            
            cell.layoutMargins = .zero
            cell.separatorInset = .zero
        }
        
        return cell
    }
}

extension SettingsViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    @objc(tableView:commitEditingStyle:forRowAtIndexPath:)
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete)
        {
            let journey = userSettings.getJourneys()[indexPath.row]
            userSettings.removeJourney(journey)
            tableView.reloadData()
            // handle delete (by removing the data from your array and updating the tableview)
        }
    }
}
