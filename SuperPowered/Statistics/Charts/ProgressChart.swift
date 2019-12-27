//
//  ProgressChart.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 24.11.2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit
class ProgressChartView: ChartView {
    
    var progressArray: [Int] = []
    
    override func graph() -> CALayer {
        let graphLayer = CALayer()
        guard !progressArray.isEmpty else { return graphLayer }
        let shift = gridWidth / progressArray.count.cgFloat
        let barWidth = shift * 0.8
        var totalShift: CGFloat = 0
        for progress in progressArray {
            if progress < 0 {
                let sadSmileLayer = CATextLayer()
                let smileFontSize = progressArray.count == 7 ? 16.cgFloat : 10.cgFloat
                sadSmileLayer.frame = CGRect(x: lowerLeftGridCorner.x + totalShift + shift * 0.1, y: horizontalLineY - smileFontSize * 1.5, width: barWidth, height: 30)
                sadSmileLayer.string = ":("
                sadSmileLayer.foregroundColor = UIColor.AppColors.red.cgColor
                sadSmileLayer.font = UIFont(name: montserratSemiBold, size: 8)
                sadSmileLayer.fontSize = smileFontSize
                sadSmileLayer.alignmentMode = .center
                sadSmileLayer.contentsScale = UIScreen.main.scale
                sadSmileLayer.isWrapped = true
                graphLayer.addSublayer(sadSmileLayer)
                totalShift += shift
            }
            else {
                let progressBar = CALayer()
                let height = barMaxHeight / maxNumber.cgFloat * progress.cgFloat
                progressBar.frame = CGRect(x: lowerLeftGridCorner.x + totalShift + shift * 0.1, y: horizontalLineY - height, width: barWidth, height: height)
                progressBar.backgroundColor = UIColor.AppColors.green.cgColor
                graphLayer.addSublayer(progressBar)
                totalShift += shift
            }
        }
    
        return graphLayer
    }
    
    override func setLabelText() {
        let progress = progressArray.reduce(0) {$0 + $1}
        let step = "step".pluralizedOrNotForNumber(number: progress)
        let direction = progress < 0 ? "backward" : "forward"
        label.text = "\(progress) \(step) \(direction) in total"
    }
}

