//
//  TabsSwitcherView.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 15.12.2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

class TabsSwitcherView: UIView {
    
    var delegate: TabSwitcherDelegate?

    let stackView = UIStackView()
    let habitsTab = TabButton()
    let statisticsTab = TabButton()
    let historyTab = TabButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    func commonInit() {
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.pinToEdges(to: self)
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(habitsTab)
        stackView.addArrangedSubview(statisticsTab)
        stackView.addArrangedSubview(historyTab)
        habitsTab.setTitle("Habits", for: .normal)
        habitsTab.isTabSelected = true
        habitsTab.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchUpInside)
        statisticsTab.setTitle("Statistics", for: .normal)
        statisticsTab.isTabSelected = false
        statisticsTab.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchUpInside)
        historyTab.setTitle("History", for: .normal)
        historyTab.isTabSelected = false
        historyTab.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchUpInside)
    }
    
    @objc func buttonPressed(sender: TabButton) {
        switch sender {
        case habitsTab:
            habitsTab.isTabSelected = true
            statisticsTab.isTabSelected = false
            historyTab.isTabSelected = false
            delegate?.tabSelected(index: 0)
        case statisticsTab:
            habitsTab.isTabSelected = false
            statisticsTab.isTabSelected = true
            historyTab.isTabSelected = false
            delegate?.tabSelected(index: 1)
        case historyTab:
            habitsTab.isTabSelected = false
            statisticsTab.isTabSelected = false
            historyTab.isTabSelected = true
            delegate?.tabSelected(index: 2)
        default:
            break
        }
    }
}

protocol TabSwitcherDelegate {
    func tabSelected(index: Int)
}
