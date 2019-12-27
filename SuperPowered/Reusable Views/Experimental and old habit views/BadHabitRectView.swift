//
//  bHabitRectView.swift
//  Triggio
//
//  Created by Дарья Селезнёва on 17/09/2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

class BadHabitRectView: UIView {
    
    var progress: Int? {
        didSet {
            contentMode = .redraw
            backgroundColor = .clear
            setNeedsDisplay()
        }
    }
    var isRed: Bool = true
    var color: UIColor = UIColor.backgroundColor

    override func draw(_ rect: CGRect) {
        guard let progress = progress else { return }
        let borderWidth = self.frame.width / (10 - 0.15 * CGFloat(progress))
        let cornerRadius = self.frame.width / (12 - 0.1 * CGFloat(progress))
        
        let outerPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height), cornerRadius: cornerRadius)
        let borderColor = isRed ? UIColor.AppColors.red : UIColor.habitViewsPlaceholderColor
        borderColor.setFill()
        outerPath.fill()
        
        let innerPath = UIBezierPath(roundedRect: CGRect(x: borderWidth, y: borderWidth, width: self.frame.width - borderWidth * 2, height: self.frame.height - borderWidth * 2), cornerRadius: cornerRadius - 1)
        color.setFill()
        innerPath.fill()

    }
}
