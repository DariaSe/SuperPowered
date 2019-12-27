//
//  StatisticsCollectionViewCell.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 17.11.2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

class StatisticsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureAppearance()
    }
    
    func configureAppearance() {
        numberLabel.font = UIFont.statisticsNumberFont
        numberLabel.textColor = UIColor.textColor
        textLabel.font = UIFont.statisticsTextFont
        textLabel.textColor = UIColor.textColor
    }
}
