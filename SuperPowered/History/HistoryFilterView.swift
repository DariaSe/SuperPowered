//
//  HistoryFilterView.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 11.12.2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

protocol HistoryFilterViewDelegate {
    func showNotes()
    func showBadHabits()
    func showGoodHabits()
}
class HistoryFilterView: UIView {
    
    var delegate: HistoryFilterViewDelegate?
    
    var showNotes: Bool = true
    var showBadHabits: Bool = true
    var showGoodHabits: Bool = true
    
    let checkedCheckboxImageName = "SqChecked"
    let uncheckedCheckboxImageName = "SqUnchecked"

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var showNotesCheckbox: UIButton!
    @IBOutlet weak var showNotesText: UIButton!
    
    @IBOutlet weak var showBadHabitsCheckbox: UIButton!
    @IBOutlet weak var showBadHabitsText: UIButton!
    
    @IBOutlet weak var showGoodHabitsCheckbox: UIButton!
    @IBOutlet weak var showGoodHabitsText: UIButton!
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        switch sender {
        case showNotesCheckbox, showNotesText:
            delegate?.showNotes()
        case showBadHabitsCheckbox, showBadHabitsText:
            delegate?.showBadHabits()
        case showGoodHabitsCheckbox, showGoodHabitsText:
            delegate?.showGoodHabits()
        default:
            break
        }
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
        Bundle.main.loadNibNamed("HistoryFilterView", owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.backgroundColor = UIColor.backgroundColor
    }
    
    func setupUI() {
        let checkboxes = [showNotesCheckbox, showBadHabitsCheckbox, showGoodHabitsCheckbox]
        let booleans = [showNotes, showBadHabits, showGoodHabits]
        for (index, checkbox) in checkboxes.enumerated() {
            let imageName = booleans[index] ? checkedCheckboxImageName : uncheckedCheckboxImageName
            checkbox?.setTintedImage(imageNamed: imageName, tintColor: .textColor, for: .normal)
        }
        let textButtons = [showNotesText, showBadHabitsText, showGoodHabitsText]
        for button in textButtons {
            button?.setTitleColor(.textColor, for: .normal)
            button?.titleLabel?.font = UIFont(name: montserratMedium, size: UIFont.filterFontSize - 2)
        }
    }
}
