//
//  WeatherSettingsViewController.swift
//  MKHome
//
//  Created by charles on 07/01/2017.
//  Copyright © 2017 charles. All rights reserved.
//

import Foundation
import UIKit

class WeatherSettingsViewController: UIViewController {
    fileprivate let userSettings = UserSettings.sharedInstance

    @IBOutlet var cityWeatherTableView: UITableView?

    override func viewWillAppear(_ animated: Bool) {
        cityWeatherTableView?.reloadData()
    }

    @IBAction func onCloseClicked(button: UIButton) {
        dismiss(animated: true)
    }
}

extension WeatherSettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userSettings.weather.getCities().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let city = userSettings.weather.getCities()[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell")!
        cell.textLabel?.text = city.name

        return cell
    }
}

extension WeatherSettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    @objc(tableView:commitEditingStyle:forRowAtIndexPath:)
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            let city = userSettings.weather.getCities()[indexPath.row]
            userSettings.weather.removeCity(city)
            tableView.reloadData()
        }
    }
}
