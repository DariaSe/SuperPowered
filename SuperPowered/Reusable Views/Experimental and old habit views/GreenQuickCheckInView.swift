//
//  GreenQuickCheckInView.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 02.12.2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

class GreenQuickCheckInView: UIView {
    
    override func draw(_ rect: CGRect) {
        let borderWidth = self.frame.width / 20
        
        let outerPath = UIBezierPath(ovalIn: self.bounds)
        let color = UIColor.AppColors.green
        color.setFill()
        outerPath.fill()
        
        let middlePath = UIBezierPath(ovalIn: CGRect(x: borderWidth, y: borderWidth, width: self.frame.width - borderWidth * 2, height: self.frame.height - borderWidth * 2))
        UIColor.backgroundCompanionColor.setFill()
        middlePath.fill()
        
        let innerPath = UIBezierPath(ovalIn: CGRect(x: borderWidth * 5, y: borderWidth * 5, width: self.frame.width - borderWidth * 10, height: self.frame.height - borderWidth * 10))
        color.setFill()
        innerPath.fill()
    }
    
}
