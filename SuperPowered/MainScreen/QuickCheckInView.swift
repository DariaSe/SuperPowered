//
//  QuickCheckInView.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 22.10.2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

protocol QuickCheckInViewDelegate {
    func badHabitButtonPressed(sender: UIButton)
    func goodHabitButtonPressed(sender: UIButton)
    func cancelCheckIn(sender: UIButton)
}

class QuickCheckInView: UIView {
    
    var progress: Int = 0
    
    var delegate: QuickCheckInViewDelegate?
    var color: UIColor = UIColor.backgroundCompanionColor {
        didSet {
            setupUI()
        }
    }
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var badHabitButtonContainer: UIView!
    @IBOutlet weak var badHabitButtonContainerWidth: NSLayoutConstraint!
    @IBOutlet weak var badHabitButtonLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var badHabitButton: UIButton!
    @IBOutlet weak var cancelBadCheckInButton: UIButton!
    
    
    @IBOutlet weak var goodHabitButtonContainer: UIView!
    @IBOutlet weak var goodHabitButtonTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var goodHabitButton: UIButton!
    
    @IBOutlet weak var cancelGoodCheckInButton: UIButton!
    
    @IBOutlet weak var badHabitWidthConstraint: NSLayoutConstraint!
    
    let badHabitView = BatteryFrameVIew()
    let goodHabitView = BatteryFrameVIew()
    
    @IBAction func habitButtonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.15, animations: {
            sender.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.badHabitView.progress -= 2
            self.goodHabitView.progress += 1
        }) { (_) in
            sender.transform = CGAffineTransform.identity
            sender == self.badHabitButton ? self.delegate?.badHabitButtonPressed(sender: sender) : self.delegate?.goodHabitButtonPressed(sender: sender)
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        delegate?.cancelCheckIn(sender: sender)
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
        Bundle.main.loadNibNamed("QuickCheckInView", owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        badHabitButton.addSubview(badHabitView)
        goodHabitButton.addSubview(goodHabitView)
        setupUI()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        contentView.addGestureRecognizer(tapGestureRecognizer)
    }
    @objc func tapped() {
        // do nothing, just to prevent the cell from selecting
    }
    
    func setupUI() {
        contentView.backgroundColor = color
        
        badHabitButtonContainer.backgroundColor = color

        badHabitView.isUserInteractionEnabled = false
        badHabitView.backgroundColor = .clear
        badHabitView.pinToEdges(to: badHabitButton)
        badHabitView.isRed = true
        badHabitView.progress = progress
        badHabitView.transform = CGAffineTransform(rotationAngle: .pi / 2)
        
        goodHabitButtonContainer.backgroundColor = color
        
        goodHabitView.isUserInteractionEnabled = false
        goodHabitView.backgroundColor = .clear
        goodHabitView.pinToEdges(to: goodHabitButton)
        goodHabitView.isRed = false
        goodHabitView.progress = progress
        goodHabitView.transform = CGAffineTransform(rotationAngle: .pi / 2)
        
        let cancelButtons = [cancelBadCheckInButton, cancelGoodCheckInButton]
        let attributes: [NSAttributedString.Key : Any] = [.font : UIFont(name: montserratMedium, size: 16)!, .foregroundColor: UIColor.AppColors.backgroundColor.withAlphaComponent(0.8), .underlineStyle: NSUnderlineStyle.single.rawValue]
        let attributedString = NSAttributedString(string: "Cancel", attributes: attributes)
        for button in cancelButtons {
            button?.setAttributedTitle(attributedString, for: .normal)
            button?.showsTouchWhenHighlighted = true
            button?.alpha = 0.0
        }
    }
    
    func adjustButtonWidth(translationX: CGFloat) {
        let containerWidth: CGFloat = 90
        let buttonWidth: CGFloat = 30
        let padding: CGFloat = 30
        badHabitWidthConstraint.constant = translationX < containerWidth ? max(0, translationX - padding * 2) : buttonWidth
        badHabitButtonLeadingConstraint.constant = translationX < containerWidth ? padding : padding + (translationX - containerWidth) / 4
        badHabitButtonContainerWidth.constant = translationX < containerWidth ? containerWidth : containerWidth + (translationX - containerWidth) / 2
        goodHabitButtonTrailingConstraint.constant = badHabitButtonLeadingConstraint.constant
    }
    
    func showFullButton() {
        badHabitWidthConstraint.constant = 30
        badHabitButtonLeadingConstraint.constant = 30
        goodHabitButtonTrailingConstraint.constant = 30
    }
    
    func prepareToCommit(isGood: Bool) {
        UIView.animate(withDuration: 0.4) {
            self.contentView.backgroundColor = isGood ? UIColor.AppColors.green : UIColor.AppColors.red
        }
        badHabitButtonContainer.isHidden = isGood ? true : false
        goodHabitButtonContainer.isHidden = isGood ? false : true
        cancelBadCheckInButton.isHidden = isGood ? true : false
        cancelGoodCheckInButton.isHidden = isGood ? false : true
    }
    func commit() {
    
        badHabitView.progress -= 2
        goodHabitView.progress += 1
        
        badHabitButton.isEnabled = false
        goodHabitButton.isEnabled = false
        
        UIView.animate(withDuration: 0.2, delay: 0.5, options: [], animations: {
            self.cancelBadCheckInButton.alpha = 1.0
            self.cancelGoodCheckInButton.alpha = 1.0
        }) { (_) in

        }
    }
    
    func restore() {
        UIView.animate(withDuration: 0.4) {
            self.contentView.backgroundColor = self.color
        }
        badHabitButtonContainer.isHidden = false
        badHabitButton.alpha = 1.0
        badHabitButton.isHidden = false
        cancelBadCheckInButton.isHidden = true
        
        goodHabitButtonContainer.isHidden = false
        goodHabitButton.alpha = 1.0
        goodHabitButton.isHidden = false
        cancelGoodCheckInButton.isHidden = true
        
        badHabitButton.isEnabled = true
        goodHabitButton.isEnabled = true
        
        badHabitView.progress = progress
        goodHabitView.progress = progress
    }
    
}
