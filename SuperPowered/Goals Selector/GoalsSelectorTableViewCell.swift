//
//  GoalsSelectorTableViewCell.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 15.11.2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

class GoalsSelectorTableViewCell: UITableViewCell {
    
    var color: UIColor?
    
    static let reuseIdentifier = "gSelectorCell"

    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var checkmarkImageView: UIImageView!
    
    func update(with goal: Goal) {
        goalLabel.text = goal.title
        goalLabel.textColor = UIColor.goalTextColor
        contentView.backgroundColor = UIColor.goalColor(index: goal.color)
        color = UIColor.goalColor(index: goal.color)
        checkmarkImageView.isHidden = goal.isSelected ? false : true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        goalLabel.font = UIFont(name: montserratSemiBold, size: 16)
        checkmarkImageView.image = UIImage(named: "Checkmark")?.withRenderingMode(.alwaysTemplate)
        checkmarkImageView.tintColor = UIColor.goalTextColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectedBackgroundView = UIView(frame: self.frame)
        selectedBackgroundView?.backgroundColor = color
        // Configure the view for the selected state
    }
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        goalLabel.text = "+  New goal..."
//        goalLabel.textColor = UIColor.textColor
//        contentView.backgroundColor = UIColor.backgroundCompanionColor
//    }
    
}
