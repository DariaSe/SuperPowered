//
//  extension UIButton.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 04.11.2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

extension UIButton {
    func setTintedImage(imageNamed: String, tintColor: UIColor, for controlState: UIControl.State) {
        let image = UIImage(named: imageNamed)
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        self.setImage(tintedImage, for: controlState)
        self.tintColor = tintColor
    }
}
