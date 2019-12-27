//
//  RedBatteryView.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 02.12.2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

class RedBatteryView: UIView {
    
    var progress: Int = 0 {
        didSet {
            indicatorView.progress = self.progress
            figureView.progress = self.progress
            figureView.setupFigure()
            if let previousProgress = previousProgress {
                if self.progress < previousProgress {
                    indicatorView.animateBorder()
                }
            }
            previousProgress = self.progress
        }
    }
    var previousProgress: Int?
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var indicatorView: BatteryView!
    @IBOutlet weak var figureView: HabitBatteryView!
    
    // MARK: - Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    func commonInit() {
        Bundle.main.loadNibNamed("RedBatteryView", owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentMode = .redraw
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        indicatorView.isRed = true
        figureView.isRed = true
    }
    
}
