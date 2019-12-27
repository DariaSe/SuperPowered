//
//  HistoryViewController.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 29.11.2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, FeedDelegate {
    var goals: [Goal] = []

    var showNotesDefault: Bool { defaults.bool(forKey: showNotesKey) }
    var showBadHabitsDefault: Bool { defaults.bool(forKey: showBadCheckInsKey) }
    var showGoodHabitsDefault: Bool { defaults.bool(forKey: showGoodCheckInsKey) }
    
    var headerView = UIView()
    var headerViewHeight = NSLayoutConstraint()
    var headerLabel = UILabel()
    
    var historyTableViewContainer = HistoryTableViewContainer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.backgroundColor
        
        setupSubviews()
        
        historyTableViewContainer.filterView.delegate = self
        setupFilter()
        
        historyTableViewContainer.delegate = self
        historyTableViewContainer.tableView.backgroundColor = .clear
        historyTableViewContainer.tableView.separatorColor = .clear
    }
    
    func setupSubviews() {
        view.addSubview(headerView)
        let marginsGuide = view.layoutMarginsGuide
        headerView.constrainToEdges(of: view, leading: 0, trailing: 0, top: nil, bottom: nil)
        headerView.topAnchor.constraint(equalTo: marginsGuide.topAnchor).isActive = true
        headerViewHeight = headerView.heightAnchor.constraint(equalToConstant: 40)
        headerViewHeight.isActive = true
        headerView.backgroundColor = .clear
        
        headerView.addSubview(headerLabel)
        headerLabel.center(in: headerView)
        headerLabel.font = UIFont.headerFont
        headerLabel.textColor = UIColor.textColor
        headerLabel.text = "History"
        
        view.addSubview(historyTableViewContainer)
        historyTableViewContainer.constrainToEdges(of: view, leading: 0, trailing: 0, top: nil, bottom: 0)
        historyTableViewContainer.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let savedGoals = Goal.loadFromFile() {
            goals = savedGoals
        }
        historyTableViewContainer.feedItems = goals.map{$0.globalHistoryInterfaceArray}.reduce([FeedItem]()) {$0 + $1}.sorted(by: >)
        historyTableViewContainer.tableView.reloadData()
    }
    
    func filter() {
        historyTableViewContainer.feedItems = goals.map{$0.globalHistoryInterfaceArray}.reduce([FeedItem]()) {$0 + $1}.sorted(by: >)
        historyTableViewContainer.tableView.reloadData()
        setupFilter()
    }
    
    func setupFilter() {
        historyTableViewContainer.setupFilter(notes: showNotesDefault, bad: showBadHabitsDefault, good: showGoodHabitsDefault)

    }
    func reload() {
        // no need for reload
    }
}

extension HistoryViewController: HistoryFilterViewDelegate {
    func showNotes() {
        defaults.set(!showNotesDefault, forKey: showNotesKey)
        filter()
    }
    
    func showBadHabits() {
        defaults.set(!showBadHabitsDefault, forKey: showBadCheckInsKey)
        filter()
    }
    
    func showGoodHabits() {
        defaults.set(!showGoodHabitsDefault, forKey: showGoodCheckInsKey)
        filter()
    }
}
