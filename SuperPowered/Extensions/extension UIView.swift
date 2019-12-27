//
//  extension UIView.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 05/10/2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

extension UIView {
    func maskRoundedCorners(cornerRadius: CGFloat) {
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height), cornerRadius: cornerRadius).cgPath
        self.layer.mask = maskLayer
    }
    
    func maskRoundedCorners(corners: UIRectCorner, cornerRadius: CGFloat) {
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height), byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
        self.layer.mask = maskLayer
    }
    
    func dropShadow(shadowRadius: CGFloat, opacity: Float, cornerRadius: CGFloat) {
        self.layer.shadowColor = UIColor.shadowColor.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowPath = CGPath(roundedRect: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height), cornerWidth: cornerRadius, cornerHeight: cornerRadius, transform: nil)
    }
    
    func dropSideShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = CGSize(width: 1, height: 0)
        self.layer.shadowRadius = 2
        self.layer.shadowPath = CGPath(rect: self.frame, transform: nil)
    }
    
    func pinToEdges(to superview: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: superview.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: superview.trailingAnchor).isActive = true
        self.topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
    }
    
    func pinToEdges(to superview: UIView, constant: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: constant).isActive = true
        self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -constant).isActive = true
        self.topAnchor.constraint(equalTo: superview.topAnchor, constant: constant).isActive = true
        self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -constant).isActive = true
    }
    
    func constrainToEdges(of superview: UIView, leading: CGFloat, trailing: CGFloat, top: CGFloat?, bottom: CGFloat?) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: leading).isActive = true
        self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -trailing).isActive = true
        if let top = top {
            self.topAnchor.constraint(equalTo: superview.topAnchor, constant: top).isActive = true
        }
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -bottom).isActive = true
        }
    }
    
    func center(in superview: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true
    }
}

extension UIView {
    var firstResponder: UIView? {
        guard !isFirstResponder else { return self }
        
        for subview in subviews {
            if let firstResponder = subview.firstResponder {
                return firstResponder
            }
        }
        return nil
    }
}

