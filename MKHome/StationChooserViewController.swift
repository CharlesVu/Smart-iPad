//
//  StationChooserViewController.swift
//  MKHome
//
//  Created by charles on 20/11/2016.
//  Copyright © 2016 charles. All rights reserved.
//

import Foundation
import UIKit

class StationChooserViewController: UIViewController
{
    @IBOutlet var searchBar: UISearchBar?
    @IBOutlet var tableView: UITableView?

    fileprivate let appSettings = AppData.sharedInstance
    fileprivate var colorScheme = ColorScheme.solarizedLight
    fileprivate var filteredStations: [(crs: String, name: String)]?
    
    var selectedCRS: String?
    var previousCRS: String?

    override func viewDidLoad()
    {
        view.backgroundColor = colorScheme.alternativeBackground
        searchBar?.backgroundColor = colorScheme.alternativeBackground
        searchBar?.tintColor = colorScheme.normalText
        searchBar?.barTintColor = colorScheme.normalText
        let textFieldInsideSearchBar = searchBar?.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = colorScheme.normalText
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "Arrival"
        {
            if let destination = segue.destination as? StationChooserViewController
            {
                destination.previousCRS = self.selectedCRS
            }
        }
    }
}

extension StationChooserViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if let filteredStations = filteredStations
        {
            selectedCRS = filteredStations[indexPath.row].crs
        }
        else
        {
            selectedCRS = appSettings.stationList[indexPath.row].crs
        }

        if let previousCRS = previousCRS, let selectedCRS = selectedCRS
        {
            UserSettings.sharedInstance.addJourney(Journey(originCRS: previousCRS, destinationCRS: selectedCRS))
            _ = self.navigationController?.popToRootViewController(animated: true)
        }
        else
        {
            self.performSegue(withIdentifier: "Arrival", sender: nil)
        }
    }
}


extension StationChooserViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let filteredStations = filteredStations
        {
            return filteredStations.count
        }
        else
        {
            return appSettings.stationList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let station: (crs: String, name: String)
        if let filteredStations = filteredStations
        {
            station = filteredStations[indexPath.row]
        }
        else
        {
            station = appSettings.stationList[indexPath.row]
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StationCell")!
        
        cell.textLabel?.text = station.name
        cell.detailTextLabel?.text = station.crs
        
        cell.detailTextLabel?.textColor = colorScheme.alternativeText
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


extension StationChooserViewController: UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) // called when text changes (including clear)
    {
        if searchText != ""
        {
            filteredStations = appSettings.stationList.filter({ (element) -> Bool in
                return element.name.lowercased().contains(searchText.lowercased())
            })
        }
        else
        {
            filteredStations = nil
        }
        self.tableView?.reloadData()
    }
}
