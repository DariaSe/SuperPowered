//
//  LittleCircleView.swift
//  Triggio
//
//  Created by Дарья Селезнёва on 06/07/2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

class GoodBadIndicatorView: UIView {
    
    var isGood: Bool? {
        didSet {
            self.backgroundColor = UIColor.backgroundColor
            setNeedsDisplay()
        }
    }
    var color: UIColor?
    
    override func draw(_ rect: CGRect) {
        // if isGood has a value, then draw a red rectangle or a green circle
        // if not, draw a circle of a given color
        
        let lineWidth = rect.width / 10 * 3
        var path = UIBezierPath()
        
        if let isGood = isGood {
            color = isGood ? UIColor.AppColors.green : UIColor.AppColors.red
            path = isGood ?
                UIBezierPath(ovalIn: CGRect(x: lineWidth / 2, y: lineWidth / 2, width: rect.width - lineWidth, height: rect.height - lineWidth)) :
                UIBezierPath(roundedRect: CGRect(x: lineWidth / 2, y: lineWidth / 2, width: rect.width - lineWidth, height: rect.height - lineWidth), cornerRadius: rect.width / 10)
            path.lineWidth = lineWidth
            color?.setStroke()
            path.stroke()
        }
        else {
            guard let color = color else { return }
            path = UIBezierPath(ovalIn: CGRect(x: lineWidth / 2, y: lineWidth / 2, width: rect.width - lineWidth, height: rect.height - lineWidth))
            path.lineWidth = lineWidth
            color.setStroke()
            path.stroke()
        }
    }
}
