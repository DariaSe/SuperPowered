//
//  FilterView.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 06.11.2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

class FilterView: UIView {
    
    var showActive: Bool {
        return defaults.bool(forKey: showActiveItemsKey)
    }
    var showFinished: Bool {
        return defaults.bool(forKey: showFinishedItemsKey)
    }
    var sortLatestFirst: Bool {
        return defaults.bool(forKey: sortLatestFirstKey)
    }
    
    let squareChecked = "SqChecked"
    let squareUnchecked = "SqUnchecked"
    
    let roundChecked = "CirChecked"
    let roundUnchecked = "CirUnchecked"
    

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var showActiveCheckbox: UIButton!
    @IBOutlet weak var showActiveText: UIButton!
    
    @IBOutlet weak var showFinishedCheckbox: UIButton!
    @IBOutlet weak var showFinishedText: UIButton!
    
    @IBAction func filterButtonsPressed(sender: UIButton) {
        if sender == showActiveCheckbox || sender == showActiveText {
            defaults.set(!showActive, forKey: showActiveItemsKey)
        }
        else if sender == showFinishedCheckbox || sender == showFinishedText {
            defaults.set(!showFinished, forKey: showFinishedItemsKey)
        }
        setupUI()
    }
    
    @IBOutlet weak var sortLabel: UILabel!
    
    @IBOutlet weak var latestFirstCheckbox: UIButton!
    @IBOutlet weak var latestFirstText: UIButton!
    
    @IBOutlet weak var oldestFirstCheckbox: UIButton!
    @IBOutlet weak var oldestFirstText: UIButton!
    
    
    @IBAction func sortButtonsPressed(_ sender: UIButton) {
        if sender == latestFirstCheckbox || sender == latestFirstText {
            defaults.set(true, forKey: sortLatestFirstKey)
        }
        else if sender == oldestFirstCheckbox || sender == oldestFirstText {
            defaults.set(false, forKey: sortLatestFirstKey)
        }
        setupUI()
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
        Bundle.main.loadNibNamed("FilterView", owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        setupUI()
    }
    
    func setupUI() {
        contentView.backgroundColor = UIColor.backgroundColor
        filterLabel.font = UIFont(name: montserratSemiBold, size: UIFont.filterFontSize)
        filterLabel.textColor = UIColor.textColor
        showActiveCheckbox.setTintedImage(
            imageNamed: showActive ? squareChecked : squareUnchecked,
            tintColor: UIColor.textColor, for: .normal)
        showFinishedCheckbox.setTintedImage(
            imageNamed: showFinished ? squareChecked : squareUnchecked,
            tintColor: UIColor.textColor, for: .normal)
        showActiveText.setTitleColor(UIColor.textColor, for: .normal)
        showActiveText.titleLabel?.font = UIFont(name: montserratMedium, size: UIFont.filterFontSize)
        showFinishedText.setTitleColor(UIColor.textColor, for: .normal)
        showFinishedText.titleLabel?.font = UIFont(name: montserratMedium, size: UIFont.filterFontSize)
        
        sortLabel.font = UIFont(name: montserratSemiBold, size: UIFont.filterFontSize)
        sortLabel.textColor = UIColor.textColor
        latestFirstCheckbox.setTintedImage(
            imageNamed: sortLatestFirst ? roundChecked : roundUnchecked,
            tintColor: UIColor.textColor, for: .normal)
        oldestFirstCheckbox.setTintedImage(
            imageNamed: sortLatestFirst ? roundUnchecked : roundChecked,
            tintColor: UIColor.textColor, for: .normal)
        latestFirstText.setTitleColor(UIColor.textColor, for: .normal)
        latestFirstText.titleLabel?.font = UIFont(name: montserratMedium, size: UIFont.filterFontSize)
        oldestFirstText.setTitleColor(UIColor.textColor, for: .normal)
        oldestFirstText.titleLabel?.font = UIFont(name: montserratMedium, size: UIFont.filterFontSize)
        
    }
}
