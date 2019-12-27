//
//  CancelDoneButtonsView.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 11/10/2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

protocol CancelDoneButtonsDelegate {
    func cancelButtonPressed(sender: UIButton)
    func doneButtonPressed(sender: UIButton)
}

class CancelDoneButtonsView: UIView {
    
    var forGoal: Bool = false {
        didSet {
            configureAppearance()
        }
    }
    
    var delegate: CancelDoneButtonsDelegate?
    
    var cancelButton = UIButton()
    var doneButton = UIButton()
    var stackView = UIStackView()
    
    var zeroHeightConstraint: NSLayoutConstraint!
    var normalHeightConstraint: NSLayoutConstraint!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        backgroundColor = .clear
        
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.cornerRadius = 15
        cancelButton.titleLabel?.font = UIFont(name: montserratRegular, size: 16)
        cancelButton.backgroundColor = UIColor.clear
        cancelButton.addTarget(self, action: #selector(cancelButtonPressed(sender:)), for: .touchUpInside)
        
        doneButton.setTitle("Done", for: .normal)
        doneButton.layer.borderWidth = 1
        doneButton.layer.cornerRadius = 15
        doneButton.titleLabel?.font = UIFont(name: montserratRegular, size: 16)
        doneButton.addTarget(self, action: #selector(doneButtonPressed(sender:)), for: .touchUpInside)
        
        stackView = UIStackView(arrangedSubviews: [cancelButton, doneButton])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView)
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
       
        let bottomConstraint = stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        bottomConstraint.priority = .init(999)
        bottomConstraint.isActive = true
        
        configureAppearance()
    }
    
    func configureAppearance() {
        forGoal ?
            cancelButton.setTitleColor(UIColor.goalTextColor, for: .normal) :
            cancelButton.setTitleColor(UIColor.textColor, for: .normal)
       
        forGoal ?
            doneButton.setTitleColor(UIColor.goalTextColor, for: .normal) :
            doneButton.setTitleColor(UIColor.textColor, for: .normal)
        
        cancelButton.layer.borderColor = forGoal ? UIColor.linesColor.cgColor : UIColor.textColor.withAlphaComponent(0.7).cgColor
        doneButton.layer.borderColor = forGoal ? UIColor.linesColor.cgColor : UIColor.textColor.withAlphaComponent(0.7).cgColor
    }
    
    @objc func cancelButtonPressed(sender: UIButton) {
        cancelButton.backgroundColor = UIColor.AppColors.achievementCircleGrey.withAlphaComponent(0.3)
        UIView.animate(withDuration: 0.3, animations: {
            self.cancelButton.backgroundColor = UIColor.clear
        }) { (true) in
            self.delegate?.cancelButtonPressed(sender: sender)
        }
    }
    
    @objc func doneButtonPressed(sender: UIButton) {
        doneButton.backgroundColor = UIColor.AppColors.achievementCircleGrey.withAlphaComponent(0.3)
        UIView.animate(withDuration: 0.3, animations: {
            self.doneButton.backgroundColor = UIColor.clear
        }) { (true) in
            self.delegate?.doneButtonPressed(sender: sender)
        }
    }
}
