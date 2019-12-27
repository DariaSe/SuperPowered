//
//  BatteryEffectsView.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 04.12.2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

class BatteryEffectsView: BatteryFrameVIew {
    
    override var isRed: Bool {
        didSet {
            setupGlowing()
            emitterCell.contents = UIImage(named: particleColor + "Particle")?.cgImage
            frameLayer.strokeColor = color.withAlphaComponent(0.6).cgColor
        }
    }
    override var framePath: UIBezierPath {
        didSet {
            frameLayer.path = framePath.cgPath
        }
    }
    
    var particleColor: String { isRed ? "Red" : "Green" }
    
    let frameLayer = CAShapeLayer()
    let increaseWidthAnimation = CABasicAnimation(keyPath: "lineWidth")
    let restoreWidthAnimation = CABasicAnimation(keyPath: "lineWidth")
    
    func setupFrameLayer() {
        frameLayer.frame = self.bounds
        frameLayer.lineWidth = lineWidth
        frameLayer.fillColor = UIColor.clear.cgColor
        
    }
    func animateFrame() {
        increaseWidthAnimation.fromValue = lineWidth
        increaseWidthAnimation.toValue = glowingLineWidth + 2
        increaseWidthAnimation.duration = 1.3
        frameLayer.add(increaseWidthAnimation, forKey: "FrameAnimation")
        restoreWidthAnimation.fromValue = glowingLineWidth + 2
        restoreWidthAnimation.toValue = lineWidth
        restoreWidthAnimation.duration = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.frameLayer.add(self.restoreWidthAnimation, forKey: "AnotherAnim")
        }
    }
    
    
    let reflectionLayer = CAGradientLayer()
    
    func setupReflection() {
        reflectionLayer.frame = chargeAreaRect
        reflectionLayer.type = .axial
        reflectionLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        reflectionLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        reflectionLayer.colors = [UIColor.clear.cgColor, UIColor.white.withAlphaComponent(0.2).cgColor, UIColor.clear.cgColor, UIColor.white.withAlphaComponent(0.2).cgColor, UIColor.clear.cgColor]
        reflectionLayer.locations = [0, 0.2, 0.5, 0.75, 1]
    }
    
    let emitterLayer = CAEmitterLayer()
    let emitterCell = CAEmitterCell()
    
    func setUpEmitterLayer() {
        emitterLayer.frame = self.bounds
        emitterLayer.lifetime = 0.0
        emitterLayer.seed = UInt32(Date().timeIntervalSince1970)
        emitterLayer.renderMode = .backToFront
        emitterLayer.drawsAsynchronously = true
        emitterLayer.emitterPosition = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        emitterLayer.emitterShape = .rectangle
        emitterLayer.emitterSize = self.bounds.size
        emitterLayer.emitterMode = .surface
    }
    
    func setUpEmitterCell() {
        emitterCell.velocity = 20.0
        emitterCell.velocityRange = 50.0
        emitterCell.alphaRange = 1.0
        
        let zeroDegreesInRadians = degreesToRadians(0.0)
        emitterCell.spin = degreesToRadians(180.0)
        emitterCell.spinRange = zeroDegreesInRadians
        emitterCell.emissionRange = degreesToRadians(360.0)
        
        emitterCell.lifetime = 0.2
        emitterCell.birthRate = 100.0
        emitterCell.xAcceleration = 0.0
        emitterCell.yAcceleration = 0.0
        emitterCell.scale = 0.2
        emitterCell.scaleRange = 0.2
    }
    
    func degreesToRadians(_ degrees: Double) -> CGFloat {
      return CGFloat(degrees * Double.pi / 180.0)
    }
    
    func emit() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.emitterLayer.lifetime = 1.0
        }
    }
    
    func stopEmitting() {
        emitterLayer.lifetime = 0.0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayers()
    }
    
    func setupLayers() {
        self.backgroundColor = .clear
        contentMode = .redraw
        setupFrameLayer()
        layer.addSublayer(frameLayer)
        setupReflection()
        layer.addSublayer(reflectionLayer)
        setUpEmitterLayer()
        setUpEmitterCell()
        layer.addSublayer(emitterLayer)
        emitterLayer.emitterCells = [emitterCell]
    }
    func setupGlowing() {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 20
        layer.shadowPath = CGPath(roundedRect: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height), cornerWidth: 10, cornerHeight: 10, transform: nil)
    }
}
