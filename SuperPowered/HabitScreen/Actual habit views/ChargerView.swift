//
//  ChargerView.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 06.12.2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

class ChargerView: UIView {
    
    var isRed: Bool = true {
        didSet {
            emitterCell.contents = UIImage(named: particleColor + "Particle")?.cgImage
        }
    }
    var isColored: Bool = false {
        didSet {
            chargerLayer.fillColor = fillColor
            chargerLayer.shadowColor = fillColor
        }
    }
    
    var particleColor: String { isRed ? "Red" : "Green" }
    
    var color: UIColor { isRed ? UIColor.AppColors.red : UIColor.AppColors.green }
    var fillColor: CGColor { isColored ? color.cgColor : UIColor.linesColor.cgColor }
    
    var width: CGFloat { self.bounds.width }
    var height: CGFloat { self.bounds.height }
    
    // MARK: - Charger
    
    let chargerLayer = CAShapeLayer()
    let fillColorAnimation = CABasicAnimation(keyPath: "fillColor")
    
    func setupCharger() {
        chargerLayer.frame = CGRect(x: 0, y: 0, width: width , height: height / 5)
        let baseRect = CGRect(x: 0, y: 0, width: width, height: height / 10)
        let basePath = UIBezierPath(roundedRect: baseRect, cornerRadius: 3)
        let contactPath = UIBezierPath(roundedRect: baseRect, cornerRadius: 3)
        let scale = CGAffineTransform(scaleX: 0.6, y: 1)
        let translate = CGAffineTransform(translationX: width / 5, y: height / 10)
        contactPath.apply(scale)
        contactPath.apply(translate)
        basePath.append(contactPath)
        
        chargerLayer.path = basePath.cgPath
        chargerLayer.fillColor = fillColor
        
        chargerLayer.shadowColor = fillColor
        chargerLayer.shadowPath = basePath.cgPath
        chargerLayer.shadowOffset = CGSize.zero
        chargerLayer.shadowOpacity = 0.4
        chargerLayer.shadowRadius = 10
    }
    
    func setupAnimation() {
        fillColorAnimation.fromValue = fillColor
        isColored = !isColored
        fillColorAnimation.toValue = fillColor
        fillColorAnimation.duration = 1.0
    }
    
    func animateColorChange() {
        setupAnimation()
        chargerLayer.add(fillColorAnimation, forKey: "Color")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.chargerLayer.fillColor = self.fillColor
            self.chargerLayer.shadowColor = self.fillColor
        }
    }
    
    
    let emitterLayer = CAEmitterLayer()
    let emitterCell = CAEmitterCell()
    
    func setupEmitter() {
        let offsetX = width / 5
        emitterLayer.frame = CGRect(x: offsetX, y: height / 5, width: width - offsetX * 2, height: height / 3)
        emitterLayer.seed = UInt32(Date().timeIntervalSince1970)
        emitterLayer.renderMode = .additive
        emitterLayer.drawsAsynchronously = true
        emitterLayer.emitterPosition = CGPoint(x: emitterLayer.bounds.midX, y: emitterLayer.bounds.minY)
        emitterLayer.emitterShape = .line
        
        emitterLayer.emitterSize = emitterLayer.frame.size
        emitterLayer.emitterMode = .outline
    }
    
    func setUpEmitterCell() {
        
        emitterCell.velocity = 200.0
        emitterCell.velocityRange = 100.0
        emitterCell.alphaRange = 1.0
        emitterLayer.lifetime = 0.0
        emitterCell.emissionLongitude = .pi
        emitterCell.lifetime = 0.4
        emitterCell.birthRate = 300.0
        emitterCell.scale = 0.2
        emitterCell.scaleRange = 0.4
    }
   
    func emit() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.emitterLayer.lifetime = 1.0
        }
    }
    
    func stopEmitting() {
        emitterLayer.lifetime = 0.0
    }
    
    // MARK: - Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
//        commonInit()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        commonInit()
    }
    func commonInit() {
        contentMode = .redraw
        self.backgroundColor = .clear
        setupLayers()
    }
    
    func setupLayers() {
        setupCharger()
        setupEmitter()
        setUpEmitterCell()
        layer.addSublayer(chargerLayer)
        layer.addSublayer(emitterLayer)
        emitterLayer.emitterCells = [emitterCell]
    }
    
}
