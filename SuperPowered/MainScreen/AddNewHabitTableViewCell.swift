//
//  AddNewHabitTableViewCell.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 17.12.2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

class AddNewHabitTableViewCell: UITableViewCell {

    static let reuseIdentifier = "AddNewHabit"

    var color: UIColor? {
        didSet {
            guard let color = color else { return }
            coloredLine.backgroundColor = color
            coloredLine.dropSideShadow()
            backgroundColor = UIColor.AppColors.backgroundCompanionColor
            setupUI()
        }
    }
    
    var coloredLine = UIView()
    var addHabitLabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupUI() {
        contentView.addSubview(coloredLine)
        coloredLine.frame = CGRect(x: 0, y: 0, width: 5, height: self.frame.height)
        contentView.addSubview(addHabitLabel)
        addHabitLabel.translatesAutoresizingMaskIntoConstraints = false
        addHabitLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        addHabitLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 35).isActive = true
        addHabitLabel.textColor = UIColor.textColor
        addHabitLabel.font = UIFont(name: montserratMedium, size: 14)
        addHabitLabel.text = "+  Add new habit..."
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        guard let color = color else { return }
        super.setSelected(selected, animated: animated)
        selectedBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        selectedBackgroundView?.backgroundColor = UIColor.AppColors.achievementCircleGrey
        let colorLine = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: self.frame.height))
        colorLine.backgroundColor = color
        selectedBackgroundView?.addSubview(colorLine)
        UIView.animate(withDuration: 0.3, animations: {
            self.selectedBackgroundView?.backgroundColor = UIColor.AppColors.backgroundCompanionColor
        })
    }
}
