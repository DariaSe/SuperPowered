//
//  ChartView.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 20.11.2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

class ChartView: UIView {
    
    var numberOfColumns: Int {
        return signaturesArray.isEmpty ? 1 : signaturesArray.count
    }
    var signaturesArray: [String] = []
    
    var maxValue: Int = 0
    var maxNumber: Int {
        var number = maxValue > 10 ? maxValue : 10
        while number % 5 != 0 {
            number += 1
        }
        return number
    }
    let label = UILabel()
    var graphLayer: CALayer?
    
    func graph() -> CALayer {
        return CALayer()
    }
    func setupGraph() {
        if graphLayer != nil {
            graphLayer!.removeFromSuperlayer()
            setNeedsDisplay()
        }
        graphLayer = graph()
        layer.addSublayer(graphLayer!)
    }
    // MARK: - Measurements
    
    var rect: CGRect { CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height * 0.8) }
    var width: CGFloat { rect.width }
    var height: CGFloat { rect.height }
    var padding: CGFloat { height / 20 }
    var upperLeftGridCorner: CGPoint { CGPoint(x: padding, y: padding) }
    var lowerLeftGridCorner: CGPoint { CGPoint(x: padding, y: height - padding) }
    var upperRightGridCorner: CGPoint { CGPoint(x: width - padding * 3, y: padding) }
    var lowerRightGridCorner: CGPoint { CGPoint(x: width - padding * 2, y: height - padding) }
    var horizontalLineY: CGFloat { height - padding * 3 }
    var gridHeight: CGFloat { height - padding * 3 }
    var gridWidth: CGFloat { width - padding * 3 }
    var barMaxHeight: CGFloat { horizontalLineY - padding }
    
    // MARK: - Guides
    
    var guidesLayer: CAShapeLayer?
    
    func guides() -> CAShapeLayer {
        let guidesLayer = CAShapeLayer()
        guidesLayer.frame = rect
        guidesLayer.masksToBounds = true
        guidesLayer.contentsScale = UIScreen.main.scale
        let path = UIBezierPath()
        path.move(to: upperLeftGridCorner)
        path.addLine(to: lowerLeftGridCorner)
        path.move(to: CGPoint(x: lowerLeftGridCorner.x, y: horizontalLineY))
        path.addLine(to: CGPoint(x: lowerRightGridCorner.x, y: horizontalLineY))
        guidesLayer.path = path.cgPath
        guidesLayer.strokeColor = UIColor.linesColor.cgColor
        guidesLayer.lineWidth = 1
        guidesLayer.lineCap = .butt
        return guidesLayer
    }
    
    func setupGuides() {
        if guidesLayer != nil {
            guidesLayer!.removeFromSuperlayer()
            setNeedsDisplay()
        }
        guidesLayer = guides()
        layer.addSublayer(guidesLayer!)
    }
    
    // MARK: - Grid
    var verticalBarsLayer: CAReplicatorLayer?
    
    func verticalBars() -> CAReplicatorLayer {
        let barsLayer = CAReplicatorLayer()
        barsLayer.frame = rect
        barsLayer.instanceCount = numberOfColumns / 2
        barsLayer.masksToBounds = true
        barsLayer.contentsScale = UIScreen.main.scale
        let bar = CALayer()
        let barWidth = gridWidth / numberOfColumns.cgFloat
        let translationX = barWidth * 2
        bar.frame = CGRect(x: upperLeftGridCorner.x + barWidth, y: upperLeftGridCorner.y, width: barWidth, height: gridHeight)
        bar.backgroundColor = UIColor.backgroundCompanionColor.withAlphaComponent(0.2).cgColor
        barsLayer.addSublayer(bar)
        barsLayer.instanceTransform = CATransform3DMakeTranslation(translationX, 0, 0)
        return barsLayer
    }
    
    var verticalGridLayer: CAReplicatorLayer?
    
    func verticalGrid() -> CAReplicatorLayer {
        let gridLayer = CAReplicatorLayer()
        gridLayer.frame = rect
        gridLayer.instanceCount = numberOfColumns
        gridLayer.masksToBounds = true
        gridLayer.contentsScale = UIScreen.main.scale
        let lineLayer = CAShapeLayer()
        let translationX = gridWidth / gridLayer.instanceCount.cgFloat
        lineLayer.frame = CGRect(x: upperLeftGridCorner.x + translationX, y: upperLeftGridCorner.y, width: 1, height: gridHeight)
        let path = UIBezierPath()
        path.move(to: CGPoint.zero)
        path.addLine(to: CGPoint(x: 0, y: lineLayer.frame.maxY))
        lineLayer.path = path.cgPath
        lineLayer.lineWidth = 0.5
        lineLayer.strokeColor = UIColor.linesColor.cgColor
        lineLayer.lineCap = .butt
        lineLayer.lineDashPattern = [1, 3]
        gridLayer.addSublayer(lineLayer)
        gridLayer.instanceTransform = CATransform3DMakeTranslation(translationX, 0, 0)
        return gridLayer
    }
    
    var horizontalGridLayer: CAReplicatorLayer?
    
    func horizontalGrid() -> CAReplicatorLayer {
        let gridLayer = CAReplicatorLayer()
        gridLayer.frame = rect
        gridLayer.instanceCount = 5
        gridLayer.masksToBounds = true
        gridLayer.contentsScale = UIScreen.main.scale
        let lineLayer = CAShapeLayer()
        let translationY = (horizontalLineY - upperLeftGridCorner.y) / 5
        lineLayer.frame = CGRect(x: upperLeftGridCorner.x, y: upperLeftGridCorner.y, width: gridWidth, height: 1)
        let path = UIBezierPath()
        path.move(to: CGPoint.zero)
        path.addLine(to: CGPoint(x: lineLayer.frame.maxX, y: 0))
        lineLayer.path = path.cgPath
        lineLayer.lineWidth = 0.5
        lineLayer.strokeColor = UIColor.linesColor.cgColor
        lineLayer.lineCap = .butt
        lineLayer.lineDashPattern = [1, 3]
        gridLayer.addSublayer(lineLayer)
        gridLayer.instanceTransform = CATransform3DMakeTranslation(0, translationY, 0)
        return gridLayer
    }
    
    var numbersLayer: CALayer?
    
    func numbers() -> CALayer {
        let numbersLayer = CALayer()
        numbersLayer.frame = rect
        let shiftY = (horizontalLineY - upperLeftGridCorner.y) / 5
        var totalShift: CGFloat = shiftY
        for i in 1...5 {
            let textLayer = CATextLayer()
            textLayer.frame = CGRect(x: rect.maxX - 10, y: horizontalLineY - totalShift, width: 12, height: 12)
            textLayer.string = String(maxNumber / 5 * i)
            textLayer.foregroundColor = UIColor.textColor.withAlphaComponent(0.8).cgColor
            textLayer.font = UIFont.graphSignaturesFont
            textLayer.fontSize = UIFont.graphNumbersFontSize
            textLayer.alignmentMode = .left
            textLayer.contentsScale = UIScreen.main.scale
            textLayer.isWrapped = true
            numbersLayer.addSublayer(textLayer)
            totalShift += shiftY
        }
        return numbersLayer
    }
    
    func setupGrid() {
        if verticalBarsLayer != nil {
            verticalBarsLayer!.removeFromSuperlayer()
            setNeedsDisplay()
        }
        verticalBarsLayer = verticalBars()
        layer.addSublayer(verticalBarsLayer!)
        
        if verticalGridLayer != nil {
            verticalGridLayer!.removeFromSuperlayer()
            setNeedsDisplay()
        }
        verticalGridLayer = verticalGrid()
        layer.addSublayer(verticalGridLayer!)
        
        if horizontalGridLayer != nil {
            horizontalGridLayer!.removeFromSuperlayer()
            setNeedsDisplay()
        }
        horizontalGridLayer = horizontalGrid()
        layer.addSublayer(horizontalGridLayer!)
        
        if numbersLayer != nil {
            numbersLayer!.removeFromSuperlayer()
            setNeedsDisplay()
        }
        numbersLayer = numbers()
        layer.addSublayer(numbersLayer!)
        setNeedsDisplay()
    }
    
    // MARK: - Signatures
    
    var signaturesLayer: CALayer?
    
    func signatures() -> CALayer {
        let signLayer = CALayer()
        signLayer.frame = rect
        guard !signaturesArray.isEmpty else { return signLayer }
        let shift = gridWidth / signaturesArray.count.cgFloat
        var totalShift: CGFloat = 0
        for string in signaturesArray {
            let textLayer = CATextLayer()
            textLayer.frame = CGRect(x: lowerLeftGridCorner.x + totalShift, y: horizontalLineY + 5, width: gridWidth / signaturesArray.count.cgFloat - 1, height: 12)
            textLayer.string = string
            textLayer.foregroundColor = UIColor.textColor.withAlphaComponent(0.8).cgColor
            textLayer.font = UIFont.graphSignaturesFont
            textLayer.fontSize = signaturesArray.count == 7 ? UIFont.graphSignaturesFontSize : UIFont.graphNumbersFontSize
            textLayer.alignmentMode = signaturesArray.count == 7 ? .center : .right
            textLayer.contentsScale = UIScreen.main.scale
            textLayer.isWrapped = true
            signLayer.addSublayer(textLayer)
            totalShift += shift
        }
        return signLayer
    }
    func setupSignatures() {
        if signaturesLayer != nil {
            signaturesLayer!.removeFromSuperlayer()
            setNeedsDisplay()
        }
        signaturesLayer = signatures()
        layer.addSublayer(signaturesLayer!)
    }
    
    func setupLabel() {
        self.addSubview(label)
        label.constrainToEdges(of: self, leading: 20, trailing: 0, top: nil, bottom: 10)
        label.textAlignment = .left
        label.font = UIFont.deselectedSegmControlFont
        label.textColor = UIColor.textColor.withAlphaComponent(0.8)
    }
    
    func setLabelText() {
        
    }
    
    override func layoutSubviews() {
        setupLayers()
    }
    
    func setupLayers() {
//        rect = self.bounds
        setupGrid()
        setupGraph()
        setupGuides()
        setupSignatures()
        setupLabel()
        setLabelText()
    }
    
}
