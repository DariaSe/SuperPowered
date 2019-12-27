//
//  BatteryFrameVIew.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 04.12.2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

class BatteryFrameVIew: UIView {
    
    var isRed: Bool = true
    
    var progress: Int = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    var modifiedProgress: Int {
        if progress < 0 {
            return 0
        }
        else if progress > 40 {
            return 40
        }
        else {
            return progress
        }
    }
    
    var completedQuartersCount: Int { isRed ? (40 - modifiedProgress) / 10 : modifiedProgress / 10 }
    var uncompletedQuarterPartsCount: Int { isRed ? (40 - modifiedProgress) % 10 : modifiedProgress % 10 }
    
    var color: UIColor { isRed ? UIColor.AppColors.red : UIColor.AppColors.green }
    
    var width: CGFloat { self.bounds.width }
    var height: CGFloat { self.bounds.height }
    
    var lineWidth: CGFloat { width / 20 }
    var glowingLineWidth: CGFloat { lineWidth * 2 }
    var halfGlowingLineWidth: CGFloat { glowingLineWidth / 2 }
    var convexPartHeight: CGFloat { height / 20 }
    var convexPartWidth: CGFloat { width / 5 }
    var convexPartOriginX: CGFloat { width / 2 - convexPartWidth / 2 }
    
    var batteryHeight: CGFloat { height - convexPartHeight - glowingLineWidth * 2 }
    var chargeAreaRect: CGRect { CGRect(x: glowingLineWidth * 2, y: glowingLineWidth * 2 + convexPartHeight, width: width - glowingLineWidth * 4, height: batteryHeight - glowingLineWidth * 3) }
    var quarterPartHeight: CGFloat { (chargeAreaRect.height - glowingLineWidth * 3) / 4 }
    
    var framePath = UIBezierPath()
    
    override func draw(_ rect: CGRect) {
        
        let convexPartPath = UIBezierPath(roundedRect: CGRect(x: convexPartOriginX, y: halfGlowingLineWidth, width: convexPartWidth, height: convexPartHeight), byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: lineWidth, height: lineWidth))
        
        let batteryPartPath = UIBezierPath(roundedRect: CGRect(x: halfGlowingLineWidth, y: convexPartHeight + halfGlowingLineWidth, width: rect.width - glowingLineWidth, height: batteryHeight), cornerRadius: lineWidth * 2)
        batteryPartPath.append(convexPartPath)
        framePath = batteryPartPath
        UIColor.backgroundColor.setFill()
        batteryPartPath.fill()
        batteryPartPath.lineWidth = glowingLineWidth
        color.withAlphaComponent(0.2).setStroke()
        batteryPartPath.stroke()
        batteryPartPath.lineWidth = lineWidth
        color.setStroke()
        batteryPartPath.stroke()
        
        var count = 0
        if completedQuartersCount > 0 {
            for _ in 1...completedQuartersCount {
                let shiftY = quarterPartHeight * count.cgFloat + glowingLineWidth * count.cgFloat
                let chargePath = UIBezierPath(roundedRect: CGRect(x: chargeAreaRect.minX, y: chargeAreaRect.maxY - quarterPartHeight - shiftY, width: chargeAreaRect.width, height: quarterPartHeight), cornerRadius: lineWidth)
                color.withAlphaComponent(0.2).setStroke()
                chargePath.lineWidth = lineWidth
                chargePath.stroke()
                color.setFill()
                chargePath.fill()
                count += 1
            }
        }
        if uncompletedQuarterPartsCount != 0 {
            let uncompletedHeight = quarterPartHeight / 10 * uncompletedQuarterPartsCount.cgFloat
            let shiftY = quarterPartHeight * (count.cgFloat - 1) + uncompletedHeight + glowingLineWidth * count.cgFloat
            let uncompletedChargePath = UIBezierPath(roundedRect: CGRect(x: chargeAreaRect.minX, y: chargeAreaRect.maxY - quarterPartHeight - shiftY, width: chargeAreaRect.width, height: uncompletedHeight), byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: lineWidth, height: lineWidth))
            color.withAlphaComponent(0.2).setStroke()
            uncompletedChargePath.lineWidth = lineWidth
            uncompletedChargePath.stroke()
            color.setFill()
            uncompletedChargePath.fill()
        }
    }
}
