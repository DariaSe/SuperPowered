//
//  DiscreteProgressBar.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 01.12.2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

class DiscreteProgressBar: UIView {
    
    // MARK: - Properties
    
    var progress: Int = 0 {
        didSet {
            setupLayers()
        }
    }
    
    var shift: CGFloat { self.frame.width / 40 }
    var instanceWidth: CGFloat { progress == 0 ? 0 : shift - 2 }
    
    // MARK: - Trace Layer
    
    let traceLayer = CAReplicatorLayer()
    let traceInstance = CALayer()
    func setupTraceLayer() {
        traceLayer.frame = self.bounds
        traceLayer.instanceCount = 40
        traceInstance.frame = CGRect(x: 1, y: 0, width: instanceWidth, height: traceLayer.frame.height)
        traceInstance.backgroundColor = UIColor.linesColor.cgColor
        traceLayer.instanceTransform = CATransform3DMakeTranslation(shift, 0, 0)
    }
    
    // MARK: - Progress Layer
    let progressLayer = CAReplicatorLayer()
    let progressInstance = CALayer()
    let borderLayer = CAShapeLayer()
    func setupProgress() {
        progressLayer.frame = self.bounds
        progressLayer.instanceCount = abs(progress)
        progressInstance.frame = CGRect(x: 1, y: 0, width: instanceWidth, height: progressLayer.frame.height)
        let progressColor = progress > 0 ? UIColor.AppColors.green : UIColor.AppColors.red
        progressInstance.backgroundColor = progressColor.cgColor
        borderLayer.frame = progressInstance.bounds
        borderLayer.path = UIBezierPath(roundedRect: borderLayer.frame, cornerRadius: 1).cgPath
        borderLayer.lineWidth = progress == 0 ? 0 : 2
        borderLayer.strokeColor = progressColor.withAlphaComponent(0.4).cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.transform = CATransform3DMakeScale(1.1, 1.1, 0)
        progressLayer.instanceTransform = CATransform3DMakeTranslation(shift, 0, 0)
    }
    
    // MARK: - Layers setup

    override func layoutSubviews() {
        commonInit()
    }
    func commonInit() {
        self.backgroundColor = UIColor.backgroundCompanionColor
        setupTraceLayer()
        layer.addSublayer(traceLayer)
        traceLayer.addSublayer(traceInstance)
        setupProgress()
        layer.addSublayer(progressLayer)
        progressLayer.addSublayer(progressInstance)
        progressInstance.addSublayer(borderLayer)
    }
    func setupLayers() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        setupTraceLayer()
        setupProgress()
        CATransaction.commit()
    }
}
