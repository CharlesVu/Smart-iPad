//
//  AppData.swift
//  MKHome
//
//  Created by charles on 20/11/2016.
//  Copyright © 2016 charles. All rights reserved.
//

import Foundation

class AppData
{
    static let sharedInstance = AppData()
    
    private(set) var stationMap: [String: String] = [:]
    private(set) var stationList: [(crs: String, name: String)] = []

    private init()
    {
        guard let libraryPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last else
        {
            return
        }
        let pathURL = URL(fileURLWithPath: libraryPath)
        let fullPath = pathURL.appendingPathComponent("station").appendingPathExtension("plist")
        TrainClient.getTrainsNames(){_ in }
        do
        {
            let data = try Data(contentsOf: fullPath)
            if let stationMap = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String: String]
            {
                self.stationMap = stationMap
                self.populateList()
            }

        }
        catch
        {
            TrainClient.getTrainsNames() { map in
                do
                {
                    self.stationMap = map
                    self.populateList()
                    let data = NSKeyedArchiver.archivedData(withRootObject: self.stationMap)
                    try data.write(to: fullPath, options: NSData.WritingOptions.atomic)
                }
                catch
                {
                    
                }
            }
            
        }
    }
    
    func populateList()
    {
        stationList.removeAll()
        
        for station in stationMap
        {
            stationList.append((crs: station.key, name: station.value))
        }
        
        stationList.sort { (e1, e2) -> Bool in
            return e1.name < e2.name
        }
    }
}
