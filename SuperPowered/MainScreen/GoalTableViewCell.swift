//
//  GoalTableViewCell.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 15/10/2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

protocol GoalCellButtonsDelegate {
    func showHideButtonPressed(sender: UIButton)
    func colorPickerButtonPressed(sender: UIButton)
}

class GoalTableViewCell: UITableViewCell {
    
    var goal: Goal? {
        didSet {
            guard let goal = goal else { return }
            contentView.backgroundColor = UIColor.goalColor(index: goal.color)
            titleTextViewContainer.text = goal.title
            titleTextViewContainer.isEditMode = goal.isEditMode
            descriptionTextViewContainer.text = goal.description
            descriptionTextViewContainer.isEditMode = goal.isEditMode
            textViewsVerticalSpacingConstraint.constant = goal.isEditMode ? 5 : -10
            
            descriptionTextViewBottomConstraint.constant = goal.isEditMode ? 80 : 5
            
            let arrowImage = goal.isCollapsed ? arrowDownImage : arrowUpImage
            showHideButton.setImage(arrowImage, for: .normal)
           
            colorPickerButton.isHidden = !goal.isEditMode
            showHideButton.isHidden = goal.isEditMode
      
            cancelDoneButtons.isHidden = !goal.isEditMode
        }
    }
    
    var buttonsDelegate: GoalCellButtonsDelegate?
    var saveDiscardDelegate: CellSaveDiscardDelegate?
    
    @IBOutlet weak var titleTextViewContainer: TextViewContainer!
    @IBOutlet weak var descriptionTextViewContainer: TextViewContainer!
    
    @IBOutlet weak var textViewsVerticalSpacingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var descriptionTextViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var cancelDoneButtons: CancelDoneButtonsView!
   
    @IBOutlet weak var colorPickerButton: UIButton!
    @IBAction func colorPickerButtonPressed(_ sender: UIButton) {
        buttonsDelegate?.colorPickerButtonPressed(sender: sender)
    }
    
    @IBOutlet weak var showHideButton: UIButton!
    @IBAction func showHideButtonPressed(_ sender: UIButton) {
        sender.image(for: .normal) == arrowDownImage ?
            UIView.transition(with: sender as UIView,
                              duration: 0.3,
                              options: .transitionFlipFromBottom,
                              animations: {
                                sender.setImage(arrowUpImage, for: .normal)
                              },
                              completion: nil) :
            UIView.transition(with: sender as UIView,
                              duration: 0.3,
                              options: .transitionFlipFromTop,
                              animations: {
                                sender.setImage(arrowDownImage, for: .normal)
                              },
                              completion: nil)
        buttonsDelegate?.showHideButtonPressed(sender: sender)
    }
    
    func configureButtons() {
        colorPickerButton.setTitleColor(UIColor.goalTextColor, for: .normal)
        colorPickerButton.titleLabel?.font = UIFont(name: montserratMedium, size: 16)
        colorPickerButton.showsTouchWhenHighlighted = true
        
        showHideButton.backgroundColor = UIColor.clear
        showHideButton.tintColor = UIColor.AppColors.backgroundColor
        
        cancelDoneButtons.forGoal = true
        cancelDoneButtons.delegate = self
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleTextViewContainer.type = .title
        descriptionTextViewContainer.type = .description
        configureButtons()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectedBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        selectedBackgroundView?.backgroundColor = UIColor.goalColor(index: goal!.color)
        let shadowView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        shadowView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        self.selectedBackgroundView?.addSubview(shadowView)
        UIView.animate(withDuration: 0.3) {
            shadowView.backgroundColor = UIColor.clear        }

        // Configure the view for the selected state
    }
}
extension GoalTableViewCell: CancelDoneButtonsDelegate {
    func cancelButtonPressed(sender: UIButton) {
        saveDiscardDelegate?.discardChanges(cell: self)
    }
    
    func doneButtonPressed(sender: UIButton) {
        if titleTextViewContainer.isValid && descriptionTextViewContainer.isValid {
        saveDiscardDelegate?.saveChanges(cell: self)
        }
        else {
            NotificationCenter.default.post(name: Notification.Name(doneButtonNKey), object: nil)
        }
    }
}
