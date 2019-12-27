//
//  HabitBatteryView.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 01.12.2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

class HabitBatteryView: UIView {
    
    // MARK: - Properties
    
    var progress: Int = 0
    var isRed: Bool = true
    var instanceCount: Int { isRed ? 40 - progress : progress }
    
    // MARK: Figure Layers
    
    let outerFigureLayer = CAShapeLayer()
    let middleFigureLayer = CAShapeLayer()
    let innerFigureLayer = CAShapeLayer()
    let maskLayer = CAShapeLayer()
    let fillLayer = CAReplicatorLayer()
    let instanceLayer = CALayer()
    
    let emitterLayer = CAEmitterLayer()
    let emitterCell = CAEmitterCell()
    
    func setupFigure() {
        var path = UIBezierPath()
        var color = UIColor.clear
        if isRed {
            path = UIBezierPath(roundedRect: self.bounds, cornerRadius: 10)
            color = UIColor.AppColors.red
        }
        else {
            path = UIBezierPath(ovalIn: self.bounds)
            color = UIColor.AppColors.green
        }
        outerFigureLayer.frame = self.bounds
        outerFigureLayer.path = path.cgPath
        outerFigureLayer.fillColor = color.cgColor
        
        middleFigureLayer.frame = self.bounds
        middleFigureLayer.path = path.cgPath
        middleFigureLayer.fillColor = UIColor.backgroundCompanionColor.cgColor
        middleFigureLayer.transform = CATransform3DMakeScale(0.9, 0.9, 0)
        
        innerFigureLayer.frame = self.bounds
        innerFigureLayer.path = path.cgPath
        innerFigureLayer.fillColor = UIColor.backgroundColor.cgColor
        innerFigureLayer.transform = CATransform3DMakeScale(0.6, 0.6, 0)
        
        maskLayer.frame = self.bounds
        maskLayer.path = path.cgPath
        
        fillLayer.frame = self.bounds
        fillLayer.instanceCount = instanceCount
        let shift = self.bounds.height / 40
        let height = (progress == 0 && !isRed) || (progress == 40 && isRed) ? 0 : shift
        instanceLayer.frame = CGRect(x: 0, y: self.bounds.height - shift, width: self.bounds.width, height: height)
        instanceLayer.backgroundColor = color.cgColor
        fillLayer.instanceTransform = CATransform3DMakeTranslation(0, -shift, 0)
        fillLayer.transform = CATransform3DMakeScale(0.6, 0.6, 0)
        fillLayer.mask = maskLayer
    }
    
    func setUpEmitterLayer() {
        emitterLayer.frame = self.bounds
        emitterLayer.seed = UInt32(Date().timeIntervalSince1970)
        emitterLayer.renderMode = .backToFront
        emitterLayer.drawsAsynchronously = true
        emitterLayer.emitterPosition = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        emitterLayer.transform = CATransform3DMakeScale(0.6, 0.6, 0)
        emitterLayer.emitterShape = .circle
        emitterLayer.emitterSize = CGSize(width: 100, height: 100)
//        emitterLayer.emitterMode = .outline
    }
    
    func setUpEmitterCell() {
        emitterCell.contents = UIImage(named: "Particle")?.cgImage
        emitterCell.velocity = 100.0
        emitterCell.velocityRange = 300.0
        emitterCell.alphaRange = 1.0
        
        let zeroDegreesInRadians = degreesToRadians(0.0)
        emitterCell.spin = degreesToRadians(180.0)
        emitterCell.spinRange = zeroDegreesInRadians
        emitterCell.emissionRange = degreesToRadians(360.0)
        
        emitterCell.lifetime = 0.2
        emitterCell.birthRate = 50.0
        emitterCell.xAcceleration = 0.0
        emitterCell.yAcceleration = 0.0
        emitterCell.scale = 0.2
        emitterCell.scaleRange = 0.2
    }
    
    func enableEmitter() {
        layer.addSublayer(emitterLayer)
    }
    func disableEmitter() {
        emitterLayer.removeFromSuperlayer()
    }
    
    func degreesToRadians(_ degrees: Double) -> CGFloat {
      return CGFloat(degrees * Double.pi / 180.0)
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
        contentMode = .redraw
        self.backgroundColor = UIColor.clear
        setupFigure()
        layer.addSublayer(outerFigureLayer)
        layer.addSublayer(middleFigureLayer)
        layer.addSublayer(innerFigureLayer)
        layer.addSublayer(fillLayer)
        fillLayer.addSublayer(instanceLayer)
        setUpEmitterLayer()
        setUpEmitterCell()
        emitterLayer.emitterCells = [emitterCell]
        
    }
    
    func dropShadow() {
        let radius = isRed ? 10 : self.bounds.width / 2
        self.dropShadow(shadowRadius: 10, opacity: 0.25, cornerRadius: radius)
    }
   
}
