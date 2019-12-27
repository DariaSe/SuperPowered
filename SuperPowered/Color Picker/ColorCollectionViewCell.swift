//
//  ColorCollectionViewCell.swift
//  Triggio
//
//  Created by Дарья Селезнёва on 15/09/2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

class ColorCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var colorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 6
        containerView.layer.borderWidth = 0.5
        containerView.layer.borderColor = UIColor.placeholderTextColor.cgColor
        containerView.backgroundColor = UIColor.backgroundColor
        
        colorView.layer.cornerRadius = 5
        colorView.layer.borderWidth = 0.5
        colorView.layer.borderColor = UIColor.placeholderTextColor.withAlphaComponent(0.5).cgColor
    }


}
