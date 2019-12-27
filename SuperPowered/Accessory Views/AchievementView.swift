//
//  AchievementView.swift
//  Triggio
//
//  Created by Дарья Селезнёва on 04/07/2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

class AchievementView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    let colors: [UIColor] = [UIColor.AppColors.green, UIColor.AppColors.turquoise, UIColor.AppColors.blue]
    
    var number: Int?
    var actualSerie: Int?
    var maximalSerie: Int?
    
    var label = UILabel()
    var shapeLayer = CAShapeLayer()
    
    func commonInit() {
        self.contentMode = .redraw
        label = UILabel(frame: CGRect(x: self.frame.width / 4,
                                      y: self.frame.height / 4,
                                      width: self.frame.width / 2,
                                      height: self.frame.height / 2))
        let fontSize = self.frame.height / 2.8
        label.contentMode = .center
        label.textAlignment = .center
        label.font = UIFont(name: montserratMedium, size: fontSize)
        label.textColor = UIColor.textColor
        
        layer.addSublayer(shapeLayer)
        
        layer.shadowColor = UIColor.shadowColor.cgColor
        layer.shadowOpacity = 0.25
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 3
        layer.shadowPath = CGPath(ellipseIn: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height), transform: nil)
        
    }
    
    func drawCircle() {
        guard let number = number, let actualSerie = actualSerie, let maximalSerie = maximalSerie else { return }
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        shapeLayer.fillColor = UIColor.clear.cgColor
        let rect = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let radius = rect.width / 2
        let startAngle: CGFloat = 3 * .pi / 2
        let outerLineWidth: CGFloat = maximalSerie > actualSerie && maximalSerie >= number ? rect.width / 40 : 0
        let arcWidth: CGFloat = rect.width / 8
        
        let outerLineLayer = CAShapeLayer()
        let outerLinePath = UIBezierPath(ovalIn: CGRect(x: outerLineWidth / 2, y: outerLineWidth / 2, width: rect.width - outerLineWidth, height: rect.height - outerLineWidth))
        outerLineLayer.path = outerLinePath.cgPath
        outerLineLayer.lineWidth = outerLineWidth
        outerLineLayer.fillColor = UIColor.clear.cgColor
        outerLineLayer.strokeColor = colors[0].cgColor
        outerLineLayer.contentsScale = UIScreen.main.scale
        shapeLayer.addSublayer(outerLineLayer)
        
        let circleLayer = CAShapeLayer()
        let circlePath = UIBezierPath(ovalIn: CGRect(x: arcWidth / 2 + outerLineWidth / 2, y: arcWidth / 2 + outerLineWidth / 2, width: rect.width - arcWidth - outerLineWidth, height: rect.height - arcWidth - outerLineWidth))
        circleLayer.path = circlePath.cgPath
        circleLayer.lineWidth = arcWidth
        circleLayer.fillColor = UIColor.clear.cgColor
        let circleColor = actualSerie >= number ? colors[0] : UIColor.linesColor
        circleLayer.strokeColor = circleColor.cgColor
        circleLayer.contentsScale = UIScreen.main.scale
        shapeLayer.addSublayer(circleLayer)
        
        let arcLayer = CAShapeLayer()
        let arcLength: CGFloat = (2 * .pi / CGFloat(number)) * CGFloat(actualSerie)
        let endAngle: CGFloat = arcLength - .pi / 2
        let arcPath = UIBezierPath(arcCenter: center, radius: radius - arcWidth / 2, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        arcLayer.path = arcPath.cgPath
        arcLayer.fillColor = UIColor.clear.cgColor
        arcLayer.lineWidth = arcWidth
        arcLayer.strokeColor = colors[0].cgColor
        arcLayer.contentsScale = UIScreen.main.scale
        shapeLayer.addSublayer(arcLayer)
        CATransaction.commit()
    }
    
    func setLabelText() {
        guard let number = number else { return }
        label.text = String(number)
        self.addSubview(label)
    }
}
