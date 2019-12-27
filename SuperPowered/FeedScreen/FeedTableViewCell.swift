//
//  FeedTableViewCell.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 11/10/2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    
    let placeholderText = "Add a note..."
    
    var saveDiscardDelegate: CellSaveDiscardDelegate?
    
    var displaysTrigger: Bool = true
    
    @IBOutlet weak var textViewDateLabelSpacingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var verticalLineAboveCircle: DottedLineView!
    @IBOutlet weak var verticalLineUnderCircle: DottedLineView!
    
    @IBOutlet weak var horizontalLine: DottedLineView!
    @IBOutlet weak var circle: GoodBadIndicatorView!
    
    @IBOutlet weak var textViewContainer: TextViewContainer!
    
    @IBOutlet weak var triggerLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var editingDateLabel: UILabel!
    
    @IBOutlet weak var cancelDoneButtons: CancelDoneButtonsView!
   
    @IBOutlet weak var buttonsHeightConstraint: NSLayoutConstraint!
    
    func configureLines() {
        verticalLineAboveCircle.backgroundColor = .clear
        verticalLineUnderCircle.backgroundColor = .clear
        
        horizontalLine.direction = .horizontal
        horizontalLine.backgroundColor = .clear
    }
    
    func configureLabels() {
        triggerLabel.numberOfLines = 1
        triggerLabel.lineBreakMode = .byTruncatingTail
        triggerLabel.textColor = UIColor.placeholderTextColor
        triggerLabel.font = UIFont(name: montserratRegular, size: 10)
        
        dateLabel.textColor = UIColor.textColor
        dateLabel.font = UIFont(name: montserratRegular, size: 10)
        
        editingDateLabel.textColor = UIColor.textColor
        editingDateLabel.font = UIFont(name: montserratRegular, size: 10)
    }
    
    func update(with feeditem: FeedItem) {
        textViewContainer.isEditMode = feeditem.isEditMode
        
        triggerLabel.text = displaysTrigger ? feeditem.triggerText : ""
        textViewDateLabelSpacingConstraint.constant = displaysTrigger ? 20 : 5
        
        if let editingDate = feeditem.editingDate {
            let text = editingDate.textForFeedScreen()
            editingDateLabel.text = "Edited \(text)"
        }
        else {
            editingDateLabel.text = ""
        }
        if let color = feeditem.color {
            circle.color = UIColor.goalColor(index: color)
        }
        switch feeditem.type {
        case .badCheckIn:
            textViewContainer.type = .badHabit
            circle.isGood = false
        case .goodCheckIn:
            textViewContainer.type = .goodHabit
            circle.isGood = true
        case .note:
            textViewContainer.type = .note
            circle.isGood = nil
        }
        if feeditem.isEditMode {
            dateLabel.text = ""
            triggerLabel.text = ""
            textViewDateLabelSpacingConstraint.constant = 5
            buttonsHeightConstraint.constant = 40
            cancelDoneButtons.isHidden = false
            textViewContainer.textView.textContainer.maximumNumberOfLines = 100
            textViewContainer.text = feeditem.text == "" ? placeholderText : feeditem.text
        }
        else {
            dateLabel.text = feeditem.creationDate.textForFeedScreen()
            buttonsHeightConstraint.constant = 0
            cancelDoneButtons.isHidden = true
            textViewContainer.text = feeditem.text
            textViewContainer.textView.textContainer.maximumNumberOfLines = feeditem.isExpanded ? 100 : 4
            textViewContainer.textView.textContainer.lineBreakMode = .byTruncatingTail
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textViewContainer.type = .note
        self.backgroundColor = .clear
        cancelDoneButtons.delegate = self
        configureLines()
        configureLabels()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectedBackgroundView = UIView(frame: self.frame)
        selectedBackgroundView?.backgroundColor = .clear
    }
    
}
extension FeedTableViewCell: CancelDoneButtonsDelegate {
    func cancelButtonPressed(sender: UIButton) {
        saveDiscardDelegate?.discardChanges(cell: self)
    }
    
    func doneButtonPressed(sender: UIButton) {
        if textViewContainer.isValid {
            saveDiscardDelegate?.saveChanges(cell: self)
        }
        else {
            NotificationCenter.default.post(name: Notification.Name(doneButtonNKey), object: nil)
        }
    }
}
