//
//  LightView.swift
//  MKHome
//
//  Created by Charles Vu on 23/12/2016.
//  Copyright © 2016 charles. All rights reserved.
//

import Foundation
import UIKit
import HomeKit

class LightView: UIView
{
    @IBOutlet weak var lightCollectionView: UICollectionView?
    fileprivate let homeManager = HMHomeManager()
    fileprivate var lights = [HMRoom: [HMCharacteristic]]()

    public var colorScheme: ColorScheme = UserSettings.sharedInstance.colorScheme.scheme {
        didSet
        {
            lightCollectionView?.reloadData()
        }
    }

    override func awakeFromNib()
    {
        lightCollectionView?.dataSource = self
        lightCollectionView?.delegate = self
    }

    override func didMoveToSuperview()
    {
        homeManager.delegate = self
    }
}

extension LightView: UICollectionViewDelegate
{
    public func collectionView(_ collectionView: UICollectionView,
                               didSelectItemAt indexPath: IndexPath)
    {
        let room = Array(lights.keys)[indexPath.row]
        if let cell = collectionView.cellForItem(at: indexPath) as? LightCell
        {
            for characteristic in lights[room]!
            {
                characteristic.readValue() { (error) in
                    if error == nil
                    {
                        if let value = characteristic.value as? Bool
                        {
                            if let reachable = characteristic.service?.accessory?.isReachable, reachable
                            {
                                characteristic.writeValue(!value)
                                { error in
                                    if let error = error {
                                        print("HomeKit: Error setting value on charcteristic '\(characteristic)': \(error.localizedDescription)")
                                    }
                                    else
                                    {
                                        cell.reloadData()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

extension LightView: UICollectionViewDataSource
{
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int
    {
        return lights.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let room = Array(lights.keys)[indexPath.row]


        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "lightCell",
                                                      for: indexPath) as! LightCell

        cell.setProperties(name: room.name, characteristics: lights[room]!)
        cell.colorScheme = colorScheme
        return cell
    }

}

extension LightView: HMHomeManagerDelegate
{
    func fetchCurrentLights()
    {
        lights.removeAll()

        if let rooms = homeManager.primaryHome?.rooms
        {
            for room in rooms
            {
                lights[room] = []

                for accessory in room.accessories
                {
                    accessory.delegate = self

                    for service in accessory.services.filter({ (service) -> Bool in
                        service.serviceType == HMServiceTypeLightbulb
                    })
                    {
                        for characteristic in service.characteristics
                        {
                            if characteristic.characteristicType == HMCharacteristicTypePowerState
                            {
                                characteristic.enableNotification(true) { _ in }
                                lights[room]?.append(characteristic)
                            }
                        }
                    }
                }

            }
        }
        lightCollectionView?.reloadData()
    }

    public func homeManagerDidUpdateHomes(_ manager: HMHomeManager)
    {
        fetchCurrentLights()
    }
}

extension LightView: HMAccessoryDelegate
{
    func accessoryDidUpdateReachability(_ accessory: HMAccessory)
    {
        lightCollectionView?.reloadData()
    }

    func accessory(_ accessory: HMAccessory,
                   service: HMService,
                   didUpdateValueFor characteristic: HMCharacteristic)
    {
        if characteristic.characteristicType == HMCharacteristicTypePowerState
        {
            lightCollectionView?.reloadData()
        }
    }
}
