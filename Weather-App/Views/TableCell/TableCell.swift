//
//  TableCell.swift
//  Weather-App
//
//  Created by Abdallah Eid on 1/17/19.
//  Copyright © 2019 Abdallah Eid. All rights reserved.
//

import Foundation
import UIKit

class TableCell: UITableViewCell {

    @IBOutlet var cellImageView: UIImageView!
    @IBOutlet var hour: UILabel!
    @IBOutlet var weather: UILabel!
    @IBOutlet var temperature: UILabel!
    @IBOutlet var smallContainerView: UIView!
    
    override func layoutSubviews() {
    }
}
