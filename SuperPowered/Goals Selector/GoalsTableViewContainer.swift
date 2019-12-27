//
//  GoalsTableViewContainer.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 14.11.2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

class GoalsTableViewContainer: UIView, UITableViewDataSource, UITableViewDelegate {
    
    var goals: [Goal] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var selectedGoalID: UInt32?
    
    var tableView = UITableView()
    
    var delegate: GoalsTableViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    func commonInit() {
        self.layer.cornerRadius = 7
        self.layer.borderWidth = 1
        self.addSubview(tableView)
        tableView.pinToEdges(to: self)
        tableView.layer.cornerRadius = 7
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "GoalsSelectorTableViewCell", bundle: nil), forCellReuseIdentifier: GoalsSelectorTableViewCell.reuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.bounces = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GoalsSelectorTableViewCell.reuseIdentifier, for: indexPath) as! GoalsSelectorTableViewCell
        cell.update(with: goals[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        for goal in goals {
            goal.isSelected = false
        }
        let goal = goals[indexPath.row]
        goal.isSelected = true
        tableView.reloadSections(IndexSet(integer: 0), with: .none)
        
        selectedGoalID = goal.id
        delegate?.goalSelected(id: goal.id)
    }
}

protocol GoalsTableViewDelegate {
    func goalSelected(id: UInt32)
}
