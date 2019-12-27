//
//  BatteryView.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 01.12.2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

class BatteryView: UIView {
    
    // MARK: - Properties
    
    var progress: Int = 10 {
        didSet {
            setupLayers()
        }
    }
    
    var isRed: Bool = false
    var counterInstanceCount: Int {
        return isRed ? 40 - progress : progress
    }
    
    let startAngle: CGFloat = 3 * .pi / 4
    let shiftAngle: CGFloat = (3 * .pi / 2) / 40
    var counterInstanceWidth: CGFloat { (progress == 0 && !isRed) || (progress == 40 && isRed) ? 0 : 2.0 }
    let counterInstanceHeight: CGFloat = 5.0
    
    // MARK: - Trace Layer
    
    let traceLayer = CAReplicatorLayer()
    let traceInstance = CALayer()
    func setupTraceLayer() {
        traceLayer.frame = self.bounds
        traceLayer.instanceCount = 40
        traceInstance.frame = CGRect(x: self.bounds.width / 2 - 1, y: self.bounds.height - 10, width: 2.0, height: counterInstanceHeight)
        traceInstance.backgroundColor = UIColor.linesColor.cgColor
        traceLayer.instanceTransform = CATransform3DMakeRotation(shiftAngle, 0.0, 0.0, 1.0)
        //        traceLayer.transform = CATransform3DMakeRotation(.pi / 4, 0.0, 0.0, 1.0)
    }
    
    // MARK: - Progress Layer
    
    let progressLayer = CAReplicatorLayer()
    let progressInstance = CALayer()
    let borderLayer = CAShapeLayer()
    
    let borderAnimation = CABasicAnimation(keyPath: "transform.scale")
    
    func setupProgressLayer() {
        progressLayer.frame = self.bounds
        progressLayer.instanceCount = counterInstanceCount
        progressInstance.frame = CGRect(x: self.bounds.width / 2 - 1, y: self.bounds.height - 10, width: counterInstanceWidth, height: counterInstanceHeight)
        progressInstance.backgroundColor = UIColor.linesColor.cgColor
        let progressColor = isRed ?  UIColor.AppColors.red : UIColor.AppColors.green
        progressInstance.backgroundColor = progressColor.cgColor
        borderLayer.frame = progressInstance.bounds
        borderLayer.path = UIBezierPath(roundedRect: borderLayer.frame, cornerRadius: 1).cgPath
        borderLayer.lineWidth = (progress == 0 && !isRed) || (progress == 40 && isRed) ? 0 : 3
        borderLayer.strokeColor = progressColor.withAlphaComponent(0.4).cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.transform = CATransform3DMakeScale(1.1, 1.1, 0)
        progressLayer.instanceTransform = CATransform3DMakeRotation(shiftAngle, 0.0, 0.0, 1.0)
        //        progressLayer.transform = CATransform3DMakeRotation(.pi / 4, 0.0, 0.0, 1.0)
    }
    
    func setupBorderAnimation() {
        borderAnimation.fromValue = 1.1
        borderAnimation.toValue = 1.6
        borderAnimation.repeatCount = 1
        borderAnimation.duration = CFTimeInterval(0.2)
    }
    
    func animateBorder() {
        borderLayer.add(borderAnimation, forKey: "BorderAnimation")
    }

    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    func commonInit() {
        self.contentMode = .redraw
        self.backgroundColor = UIColor.clear
        layer.transform = CATransform3DMakeRotation(.pi / 4, 0.0, 0.0, 1.0)
        setupTraceLayer()
        layer.addSublayer(traceLayer)
        traceLayer.addSublayer(traceInstance)
        setupProgressLayer()
        layer.addSublayer(progressLayer)
        progressLayer.addSublayer(progressInstance)
        progressInstance.addSublayer(borderLayer)
        setupBorderAnimation()
    }
    
    func setupLayers() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        setupTraceLayer()
        setupProgressLayer()
        CATransaction.commit()
    }
    
}
