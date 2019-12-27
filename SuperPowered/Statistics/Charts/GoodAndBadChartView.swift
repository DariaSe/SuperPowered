//
//  GoodAndBadChartView.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 23.11.2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

class GoodAndBadChartView: ChartView {
    var goodCheckIns: [Int] = []
    var badCheckIns: [Int] = []
    
    override func graph() -> CALayer {
        let graphLayer = CALayer()
        guard !goodCheckIns.isEmpty && !badCheckIns.isEmpty else { return graphLayer }
        guard maxValue != 0 else { return graphLayer }
        let shift = gridWidth / goodCheckIns.count.cgFloat
        let barWidth = shift / 3
        var totalShift: CGFloat = 0
        let goodBarsLayer = CALayer()
        let badBarsLayer = CALayer()
        for checkInsCount in goodCheckIns {
            let goodBar = CALayer()
            let height = barMaxHeight / maxNumber.cgFloat * checkInsCount.cgFloat
            goodBar.frame = CGRect(x: lowerLeftGridCorner.x + totalShift + barWidth / 2, y: horizontalLineY - height, width: barWidth, height: height)
            goodBar.backgroundColor = UIColor.AppColors.green.cgColor
            goodBarsLayer.addSublayer(goodBar)
            totalShift += shift
        }
        totalShift = 0
        for checkInsCount in badCheckIns {
            let badBar = CALayer()
            let height = barMaxHeight / maxNumber.cgFloat * checkInsCount.cgFloat
            badBar.frame = CGRect(x: lowerLeftGridCorner.x + totalShift + barWidth + barWidth / 2, y: horizontalLineY - height, width: barWidth, height: height)
            badBar.backgroundColor = UIColor.AppColors.red.cgColor
            badBarsLayer.addSublayer(badBar)
            totalShift += shift
        }
        graphLayer.addSublayer(goodBarsLayer)
        graphLayer.addSublayer(badBarsLayer)
        
        return graphLayer
    }
    
    override func setLabelText() {
        let goods = goodCheckIns.reduce(0) {$0 + $1}
        let bads = badCheckIns.reduce(0) {$0 + $1}
        let decision = "decision".pluralizedOrNotForNumber(number: goods)
        let setback = "setback".pluralizedOrNotForNumber(number: bads)
        label.text = "\(goods) right \(decision), \(bads) \(setback) in total"
    }
}
