//
//  TabButton.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 15.12.2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

class TabButton: UIButton {
    
    var isTabSelected: Bool = false {
        didSet {
            if isTabSelected {
                setSelected()
            }
            else {
                deselect()
            }
        }
    }
    var selectedColor: UIColor = UIColor.textColor
    var deselectedColor: UIColor = UIColor.backgroundColor
    
    var indicatorColor: CGColor { isTabSelected ? selectedColor.cgColor : deselectedColor.cgColor }
    
    var deselectedTextColor: UIColor = UIColor.textColor.withAlphaComponent(0.5)
    
    var textColor: CGColor { isTabSelected ? selectedColor.cgColor : deselectedTextColor.cgColor }
    
    var width: CGFloat { self.bounds.width }
    var height: CGFloat { self.bounds.height }
    var indicatorHeight: CGFloat { height / 10 }
    var indicatorWidth: CGFloat { width * 0.8 }
    
    let indicatorView = UIView()
    
    func setSelected() {
        tintColor = UIColor.textColor
        UIView.animate(withDuration: 0.3) {
            self.backgroundColor = UIColor.backgroundCompanionColor
            self.indicatorView.backgroundColor = self.selectedColor
        }
    }
    
    func deselect() {
        tintColor = UIColor.textColor.withAlphaComponent(0.1)
        UIView.animate(withDuration: 0.3) {
            self.backgroundColor = UIColor.clear
            self.indicatorView.backgroundColor = self.deselectedColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
   
    func commonInit() {
        tintColor = UIColor.textColor.withAlphaComponent(0.4)
        titleLabel?.font = UIFont.triggerFont
        self.addSubview(indicatorView)
        indicatorView.constrainToEdges(of: self, leading: 0, trailing: 0, top: nil, bottom: 0)
        indicatorView.heightAnchor.constraint(equalToConstant: 4).isActive = true
        indicatorView.backgroundColor = deselectedColor
    }

}
