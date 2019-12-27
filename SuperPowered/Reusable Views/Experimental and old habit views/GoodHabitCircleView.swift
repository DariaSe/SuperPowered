//
//  GoodHabitCircleView.swift
//  Triggio
//
//  Created by Дарья Селезнёва on 17/09/2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

class GoodHabitCircleView: UIView {
    // у серых плейсхолдеров прогресс равен 40
    
    var progress: Int? {
        didSet {
            backgroundColor = .clear
            contentMode = .redraw
            setNeedsDisplay()
        }
    }
    var isGreen: Bool = true
    
    override func draw(_ rect: CGRect) {
         guard let progress = progress else { return }
        let borderWidth = self.frame.width / (4 + 0.15 * CGFloat(progress))
        let outerPath = UIBezierPath(ovalIn: CGRect(x: borderWidth / 2, y: borderWidth / 2, width: self.frame.width - borderWidth, height: self.frame.height - borderWidth))
        outerPath.lineWidth = borderWidth
        let color = isGreen ? UIColor.AppColors.green : UIColor.habitViewsPlaceholderColor
        color.setStroke()
        outerPath.stroke()
    }
}
