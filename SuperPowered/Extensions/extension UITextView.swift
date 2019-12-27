//
//  extension UITextView.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 04/10/2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

extension UITextView {
    func clear(placeholder: String) {
        if self.text == placeholder {
            self.text = ""
        }
    }
    
    func show(placeholder: String, placeholderColor: UIColor) {
        if self.text == "" {
            self.text = placeholder
            self.textColor = placeholderColor
        }
    }

    func isValid(placeholder: String) -> Bool {
        var carriageReturnsNumber = 0
        for character in self.text {
            if character == "\n" {
            carriageReturnsNumber += 1
            }
        }
        let consistsOfCarriageReturns = carriageReturnsNumber == self.text.count
        return self.text != "" && self.text != placeholder && !consistsOfCarriageReturns
    }
    
    func shake() {
        let midX = self.center.x
        let midY = self.center.y
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.06
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = CGPoint(x: midX - 5, y: midY)
        animation.toValue = CGPoint(x: midX + 5, y: midY)
        self.layer.add(animation, forKey: "position")
    }
}
