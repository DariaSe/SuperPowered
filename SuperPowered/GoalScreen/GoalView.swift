//
//  GoalView.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 16.11.2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

class GoalView: UIView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var textViewContainersContainer: UIView!
    @IBOutlet weak var titleTextViewContainer: TextViewContainer!
    @IBOutlet weak var descriptionTextViewContainer: TextViewContainer!
    
    @IBOutlet weak var textViewsSpacingConstraint: NSLayoutConstraint!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    func commonInit() {
        Bundle.main.loadNibNamed("GoalView", owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
    }
    
    func updateWithGoal(goal: Goal) {
        textViewContainersContainer.backgroundColor = UIColor.goalColor(index: goal.color)
        titleTextViewContainer.type = .title
        titleTextViewContainer.isEditMode = goal.isEditMode
        titleTextViewContainer.text = goal.title
        
        descriptionTextViewContainer.type = .description
        descriptionTextViewContainer.isEditMode = goal.isEditMode
        descriptionTextViewContainer.text = goal.description
        
        textViewsSpacingConstraint.constant = goal.isEditMode ? 5 : -10
    }

}
