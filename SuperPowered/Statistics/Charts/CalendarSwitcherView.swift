//
//  CalendarSwitcherView.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 21.11.2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

enum CalendarInterval: Int {
    case day = 0
    case week
    case month
}

class CalendarSwitcherView: UIView {
    
    // MARK: - Properties
    
    var text: String = "" {
        didSet {
            label.text = text
        }
    }
    
    var currentInterval: CalendarInterval {
        return CalendarInterval(rawValue: defaults.integer(forKey: calendarIntervalKey)) ?? CalendarInterval(rawValue: 1)!
    }
    
    var delegate: CalendarSwitcherDelegate?
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var dateIntervalSegmentedControl: UISegmentedControl!
    
    @IBAction func dateIntervalChanged(_ sender: UISegmentedControl) {
        defaults.set(dateIntervalSegmentedControl.selectedSegmentIndex, forKey: calendarIntervalKey)
        delegate?.switchTo(interval: currentInterval)
    }
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var previousButton: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        if sender == previousButton {
            delegate?.showPrevious(interval: currentInterval)
        }
        if sender == nextButton {
            delegate?.showNext(interval: currentInterval)
        }
    }
    
    
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
        Bundle.main.loadNibNamed("CalendarSwitcherView", owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        dateIntervalSegmentedControl.selectedSegmentIndex = defaults.integer(forKey: calendarIntervalKey)
        setupUI()
    }
    
    func setupUI() {
        label.text = text
        label.font = UIFont.habitFont
        label.textColor = UIColor.textColor
        previousButton.setTintedImage(imageNamed: "Back", tintColor: UIColor.textColor.withAlphaComponent(0.7), for: .normal)
        nextButton.setTintedImage(imageNamed: "Forward", tintColor: UIColor.textColor.withAlphaComponent(0.7), for: .normal)
        dateIntervalSegmentedControl.configureAppearance()
    }

}

protocol CalendarSwitcherDelegate {
    func showPrevious(interval: CalendarInterval)
    func showNext(interval: CalendarInterval)
    func switchTo(interval: CalendarInterval)
}
