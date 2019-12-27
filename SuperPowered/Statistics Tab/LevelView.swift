//
//  LevelView.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 18.11.2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

class LevelView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progressVIew: UIProgressView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    func commonInit() {
        Bundle.main.loadNibNamed("LevelView", owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
    }
    func configureAppearance() {
        contentView.backgroundColor = UIColor.backgroundColor
//        self.maskRoundedCorners(cornerRadius: 10)
        self.dropShadow(shadowRadius: 6, opacity: 0.25, cornerRadius: 10)
        levelLabel.font = UIFont(name: montserratSemiBold, size: 20)
        levelLabel.textColor = UIColor.textColor
        progressLabel.font = UIFont(name: montserratMedium, size: 16)
        progressLabel.textColor = UIColor.textColor
        progressLabel.alpha = 0.9
        progressVIew.progressTintColor = UIColor.AppColors.green
        progressVIew.trackTintColor = UIColor.linesColor
        progressVIew.dropShadow(shadowRadius: 2, opacity: 0.25, cornerRadius: 1)
    }
    
    func update(manager: StatisticsManager) {
        levelLabel.text = "Level \(manager.level)"
        progressLabel.text = "\(manager.totalProgress) / \(manager.nextLevelProgress)"
        progressVIew.progress = Float((manager.totalProgress.cgFloat - manager.currentLevelProgress.cgFloat) / (manager.nextLevelProgress.cgFloat - manager.currentLevelProgress.cgFloat))
    }
}
