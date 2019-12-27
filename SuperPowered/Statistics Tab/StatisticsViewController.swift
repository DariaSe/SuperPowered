//
//  StatisticsViewController.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 18.11.2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {
    
    var statisticsManager = StatisticsManager()
    var chartManager = ChartManager()
    
    var headerView = UIView()
    var headerLabel = UILabel()

    var statisticsContainer = StatisticContainer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeader()
        view.addSubview(statisticsContainer)
        statisticsContainer.constrainToEdges(of: view, leading: 5, trailing: 5, top: nil, bottom: nil)
        statisticsContainer.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 40).isActive = true
        statisticsContainer.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: 0).isActive = true
        loadGoals()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor.backgroundColor
        loadGoals()
        statisticsContainer.configureAppearance()
    }
        
    func loadGoals() {
        if let savedGoals = Goal.loadFromFile() {
            statisticsManager.goals = savedGoals
            chartManager.goals = savedGoals
            statisticsContainer.statisticsItems = statisticsManager.statisticsItems
            statisticsContainer.chartManager = chartManager
        }
        statisticsContainer.setupUI()
    }
    
    func setupHeader() {
        view.addSubview(headerView)
        headerView.constrainToEdges(of: view, leading: 0, trailing: 0, top: nil, bottom: nil)
        headerView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        headerView.backgroundColor = .backgroundColor
        
        headerView.addSubview(headerLabel)
        headerLabel.center(in: headerView)
        headerLabel.textAlignment = .center
        headerLabel.font = UIFont.headerFont
        headerLabel.textColor = UIColor.textColor
        headerLabel.text = "Statistics"
    }
}

