//
//  TunnelView.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 30.11.2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

class TunnelView: UIView {
    
    var progress: Int = 0
    
    var isRed: Bool = false
    
    // green scale min, red - max
    var scale: CGFloat {
        return isRed ? (40 - progress.cgFloat + 3) / 40 : (progress.cgFloat + 3) / 25
    }
    
    var blackIntensity: CGFloat {
        return isRed ? (40 - progress.cgFloat + 3) / 40 : (progress.cgFloat + 3) / 40
    }
    
    // MARK: - Tunnel
    
    var tunnelLayer: CAReplicatorLayer?
    
    func tunnel() -> CAReplicatorLayer {
        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.frame = self.bounds
        replicatorLayer.instanceCount = 30
        replicatorLayer.contentsScale = UIScreen.main.scale
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.type = .radial
        gradientLayer.colors = [UIColor.black.withAlphaComponent(0.9).cgColor, UIColor.white.cgColor]
        gradientLayer.locations = [0.8, 2]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        let grPath = UIBezierPath(ovalIn: gradientLayer.bounds).cgPath
        let gradientMaskLayer = CAShapeLayer()
        gradientMaskLayer.path = grPath
        gradientLayer.mask = gradientMaskLayer
        replicatorLayer.addSublayer(gradientLayer)
        replicatorLayer.instanceTransform = CATransform3DMakeScale(0.9, 0.9, 0)
        self.layer.addSublayer(replicatorLayer)
        return replicatorLayer
    }
    func setupTunnel() {
        if tunnelLayer != nil {
            tunnelLayer!.removeFromSuperlayer()
            setNeedsDisplay()
        }
        tunnelLayer = tunnel()
        setNeedsDisplay()
        layer.addSublayer(tunnelLayer!)
    }
    
    // MARK: - Glowing something
    
    var figureLayer: CALayer?
    func figure() -> CALayer {
        let figureLayer = CALayer()
        figureLayer.frame = self.bounds
        let figureGlowingReplicator = CAReplicatorLayer()
        figureGlowingReplicator.frame = figureLayer.bounds
        figureGlowingReplicator.contentsScale = UIScreen.main.scale
        figureGlowingReplicator.instanceCount = 10
        let glowLayer = CAShapeLayer()
        glowLayer.frame = figureGlowingReplicator.bounds
        let greenPath = UIBezierPath(ovalIn: glowLayer.bounds).cgPath
        let redPath = UIBezierPath(roundedRect: glowLayer.bounds, cornerRadius: 16).cgPath
        glowLayer.path = greenPath
        let red = UIColor.AppColors.red.withAlphaComponent(0.1).cgColor
        let green = UIColor.AppColors.green.withAlphaComponent(0.1).cgColor
        glowLayer.fillColor = isRed ? red : green
        figureGlowingReplicator.addSublayer(glowLayer)
        figureGlowingReplicator.instanceTransform = CATransform3DMakeScale(0.9, 0.9, 0)
        figureGlowingReplicator.transform = CATransform3DMakeScale(0.95 * scale, 0.95 * scale, 0)
        figureLayer.addSublayer(figureGlowingReplicator)
        
        let coreFigureLayer = CAShapeLayer()
        coreFigureLayer.frame = figureLayer.bounds
        coreFigureLayer.path = isRed ? redPath : greenPath
        let intenseRed = UIColor.AppColors.red.withAlphaComponent(0.8).cgColor
        let intenseGreen = UIColor.AppColors.green.withAlphaComponent(0.8).cgColor
        coreFigureLayer.fillColor = isRed ? intenseRed : intenseGreen
        coreFigureLayer.transform = CATransform3DMakeScale(0.4 * scale, 0.4 * scale, 0)
        figureLayer.addSublayer(coreFigureLayer)
        
        let centerLayer = CAShapeLayer()
        centerLayer.frame = figureLayer.bounds
        centerLayer.path = isRed ? redPath : greenPath
        centerLayer.fillColor = UIColor.backgroundColor.withAlphaComponent(0.7 * blackIntensity).cgColor
        centerLayer.transform = CATransform3DMakeScale(0.2 * scale, 0.2 * scale, 0)
        figureLayer.addSublayer(centerLayer)
        
        return figureLayer
    }
    func setupFigure() {
        if figureLayer != nil {
            figureLayer!.removeFromSuperlayer()
            setNeedsDisplay()
        }
        figureLayer = figure()
        setNeedsDisplay()
        layer.addSublayer(figureLayer!)
    }
    // MARK: - Shadow
    var shadowLayer: CAGradientLayer?
    func shadow() -> CAGradientLayer {
        let shadowLayer = CAGradientLayer()
        shadowLayer.frame = self.bounds
        shadowLayer.type = .axial
        shadowLayer.colors = [UIColor.black.withAlphaComponent(0.4).cgColor, UIColor.clear.cgColor]
        shadowLayer.locations = [0, 1]
        return shadowLayer
    }
    func setupShadow() {
        if shadowLayer != nil {
            shadowLayer!.removeFromSuperlayer()
            setNeedsDisplay()
        }
        shadowLayer = shadow()
        mask()
        layer.addSublayer(shadowLayer!)
    }
    // MARK: - Mask
    
    func mask() {
        let path = UIBezierPath(ovalIn: self.bounds).cgPath
        let maskLayer = CAShapeLayer()
        maskLayer.path = path
        shadowLayer!.mask = maskLayer
    }
    
    // MARK: - Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = .clear
        setupLayers()
    }
    
    func setupLayers() {
        setupTunnel()
        setupFigure()
        setupShadow()
    }
    
}
