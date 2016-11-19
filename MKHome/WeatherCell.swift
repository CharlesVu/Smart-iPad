//
//  WeatherCell.swift
//  MKHome
//
//  Created by charles on 16/11/2016.
//  Copyright © 2016 charles. All rights reserved.
//

import Foundation
import UIKit

class WeatherCell: UICollectionViewCell
{
    @IBOutlet weak var icon: SKYIconView?
    @IBOutlet weak var temperature: UILabel?
    @IBOutlet weak var time: UILabel?

    override func prepareForReuse()
    {
        super.prepareForReuse()
        icon?.alpha = 0
        temperature?.alpha = 0
    }
}
