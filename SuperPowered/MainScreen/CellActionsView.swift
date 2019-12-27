//
//  CellActionsView.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 02.11.2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

protocol CellActionsDelegate {
    func addNote(sender: UIButton)
    func edit(sender: UIButton)
    func restart(sender: UIButton)
    func delete(sender: UIButton)
}

class CellActionsView: UIView {
    
    var hasNewNoteButton: Bool = true {
        didSet {
            setupUI()
        }
    }
    var color: UIColor = UIColor.backgroundColor
    
    var delegate: CellActionsDelegate?
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var newNoteLabel: UILabel!
    @IBOutlet weak var newNoteButton: UIButton!
    @IBAction func buttonPressed(_ sender: UIButton) {
        switch sender {
        case newNoteButton:
            delegate?.addNote(sender: sender)
        case editButton:
            delegate?.edit(sender: sender)
        case restartButton:
            delegate?.restart(sender: sender)
        case deleteButton:
            delegate?.delete(sender: sender)
        default:
            fatalError("Unknown button")
        }
        UIView.animate(withDuration: 0.2, animations: {
            sender.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) { (_) in
            sender.transform = CGAffineTransform.identity
            self.disappear()
        }
    }
    
    @IBOutlet weak var editLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
 
    @IBOutlet weak var restartLabel: UILabel!
    @IBOutlet weak var restartButton: UIButton!
 
    
    @IBOutlet weak var deleteLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    func commonInit() {
        Bundle.main.loadNibNamed("CellActionsView", owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        setupUI()
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.addGestureRecognizer(tapRecognizer)
    }
    func setupUI() {
        self.backgroundColor = color.withAlphaComponent(0.7)
        contentView.backgroundColor = color.withAlphaComponent(0.7)
        let labels = [newNoteLabel, editLabel, restartLabel, deleteLabel]
        for label in labels {
            label?.font = UIFont(name: montserratSemiBold, size: 12)
            label?.textColor = UIColor.textColor
        }
        let buttons = [newNoteButton, editButton, restartButton, deleteButton]
        let imageNames = ["newNoteF", "editF", "restartMy", "deleteF"]
        for (index, button) in buttons.enumerated() {
            button?.setTintedImage(imageNamed: imageNames[index], tintColor: UIColor.textColor, for: .normal)
        }
    }
    
    @objc func tapped() {
        disappear()
    }
    
    func animateAlpha(endAlpha: CGFloat) {
        let labels = [newNoteLabel, editLabel, restartLabel, deleteLabel]
        let buttons = [newNoteButton, editButton, restartButton, deleteButton]
        var delay: TimeInterval = 0.0
        for (index, element) in labels.enumerated() {
            UIView.animate(withDuration: 0.2, delay: delay, options: [], animations: {
                element?.alpha = endAlpha
                buttons[index]?.alpha = endAlpha
            }, completion: nil)
            delay += 0.05
        }
    }
    
    func disappear() {
        animateAlpha(endAlpha: 0.0)
        UIView.animate(withDuration: 0.3, delay: 0.2, options: [], animations: {
            self.alpha = 0.0
        }, completion: nil)
    }
    func appear() {
        UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
            self.alpha = 1.0
        }, completion: nil)
        animateAlpha(endAlpha: 1.0)
    }
}
