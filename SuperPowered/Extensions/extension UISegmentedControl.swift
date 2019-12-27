//
//  extension UISegmentedControl.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 29.11.2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

extension UISegmentedControl {
    func configureAppearance() {
        let selectedFont = UIFont.selectedSegmControlFont
        let deselectedFont = UIFont.deselectedSegmControlFont
        if #available(iOS 13.0, *) {
            self.selectedSegmentTintColor = UIColor.white.withAlphaComponent(0.7)
            self.backgroundColor = UIColor.backgroundCompanionColor
            let selectedAttributes = [NSAttributedString.Key.font : selectedFont!, NSAttributedString.Key.foregroundColor : UIColor.goalTextColor]
            let deselectedAttributes = [NSAttributedString.Key.font : deselectedFont!, NSAttributedString.Key.foregroundColor : UIColor.textColor]
            self.setTitleTextAttributes(selectedAttributes, for: .selected)
            self.setTitleTextAttributes(deselectedAttributes, for: .normal)
        }
        else {
            self.tintColor = UIColor.textColor
            let selectedAttributes = [NSAttributedString.Key.font : selectedFont!, NSAttributedString.Key.foregroundColor : UIColor.goalTextColor]
            let deselectedAttributes = [NSAttributedString.Key.font : deselectedFont!, NSAttributedString.Key.foregroundColor : UIColor.textColor.withAlphaComponent(0.8)]
            self.setTitleTextAttributes(selectedAttributes, for: .selected)
            self.setTitleTextAttributes(deselectedAttributes, for: .normal)
        }
    }
}
