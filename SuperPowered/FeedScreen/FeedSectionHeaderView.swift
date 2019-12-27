//
//  FeedSectionHeaderView.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 18.12.2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

class FeedSectionHeaderView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var verticalLineAboveCircle: DottedLineView!
    
    @IBOutlet weak var verticalLineBelowCircle: DottedLineView!
    
    @IBOutlet weak var circleView: UIView!
    
    @IBOutlet weak var horizontalLine: DottedLineView!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    func setupUI() {
        verticalLineAboveCircle.backgroundColor = .clear
        verticalLineBelowCircle.backgroundColor = .clear
        
        horizontalLine.direction = .horizontal
        horizontalLine.backgroundColor = .clear
        
        circleView.backgroundColor = UIColor(netHex: 0xDB9A4E)
        circleView.maskRoundedCorners(cornerRadius: circleView.bounds.height / 2)
        
        dateLabel.font = UIFont(name: montserratSemiBold, size: 16)
        dateLabel.textColor = UIColor.textColor.withAlphaComponent(0.5)
    }
    
    func setupText(text: String) {
        dateLabel.text = text
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
        Bundle.main.loadNibNamed("FeedSectionHeaderView", owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        setupUI()
    }
}
