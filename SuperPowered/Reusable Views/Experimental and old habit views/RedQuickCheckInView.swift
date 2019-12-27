//
//  RedQuickCheckInView.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 02.12.2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

class RedQuickCheckInView: UIView {
    
    override func draw(_ rect: CGRect) {
        let borderWidth = self.frame.width / 20
        let cornerRaduis = self.frame.width / 8
        
        let outerPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height), cornerRadius: cornerRaduis)
        let color = UIColor.AppColors.red
        color.setFill()
        outerPath.fill()
        
        let middlePath = UIBezierPath(roundedRect: CGRect(x: borderWidth, y: borderWidth, width: self.frame.width - borderWidth * 2, height: self.frame.height - borderWidth * 2), cornerRadius: cornerRaduis * 0.75)
        UIColor.backgroundCompanionColor.setFill()
        middlePath.fill()
        
        let innerPath = UIBezierPath(roundedRect: CGRect(x: borderWidth * 5, y: borderWidth * 5, width: self.frame.width - borderWidth * 10, height: self.frame.height - borderWidth * 10), cornerRadius: cornerRaduis * 0.5)
        color.setFill()
        innerPath.fill()
    }
}
