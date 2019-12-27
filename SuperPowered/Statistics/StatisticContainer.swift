//
//  StatisticContainer.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 08.12.2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

class StatisticContainer: UIView {

    var statisticsItems: [StatisticsItem] = []
    
    var chartManager = ChartManager()
    
    let scrollView = UIScrollView()
    
    let stackView = UIStackView()

    let numbersView = StatisticsCollectionViewContainer()
    let calendarSwitcher = CalendarSwitcherView()
    let progressChart = ProgressChartView()
    let goodBadBarChart = GoodAndBadChartView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
       
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }
    
    func setupSubviews() {
        self.backgroundColor = UIColor.backgroundColor
        self.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.pinToEdges(to: self)
        scrollView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let padding: CGFloat = isPhone ? 5 : 20
        stackView.pinToEdges(to: scrollView, constant: padding)
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -padding * 2).isActive = true
        scrollView.addSubview(stackView)
        stackView.spacing = isPhone ? 10 : 16
        stackView.axis = .vertical
        
        stackView.addArrangedSubview(numbersView)
        stackView.addArrangedSubview(calendarSwitcher)
        calendarSwitcher.delegate = self
        stackView.addArrangedSubview(progressChart)
        stackView.addArrangedSubview(goodBadBarChart)
    }
    
    func setupConstraints() {
        
        numbersView.translatesAutoresizingMaskIntoConstraints = false
        numbersView.heightAnchor.constraint(equalToConstant: 150).isActive = true
   
        calendarSwitcher.translatesAutoresizingMaskIntoConstraints = false
        calendarSwitcher.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        progressChart.translatesAutoresizingMaskIntoConstraints = false
        progressChart.heightAnchor.constraint(equalTo: progressChart.widthAnchor, multiplier: 0.6).isActive = true
        
        goodBadBarChart.translatesAutoresizingMaskIntoConstraints = false
        goodBadBarChart.heightAnchor.constraint(equalTo: goodBadBarChart.widthAnchor, multiplier: 0.6).isActive = true
    }
    
    func setupNumbersView() {
        
    }
    func setupUI() {
        
        numbersView.statisticsItems = statisticsItems
        numbersView.collectionView.reloadData()
       
        calendarSwitcher.text = chartManager.intervalTextRepresentation
        calendarSwitcher.nextButton.isEnabled = chartManager.intervalsBackwardFromNow != 0
        
        progressChart.signaturesArray = chartManager.intervalSignatures
        progressChart.progressArray = chartManager.progressArray
        progressChart.maxValue = chartManager.maxProgress
        progressChart.setupLayers()
        
        goodBadBarChart.signaturesArray = chartManager.intervalSignatures
        goodBadBarChart.goodCheckIns = chartManager.goodCheckInsCountsArray
        goodBadBarChart.badCheckIns = chartManager.badCheckInsCountsArray
        goodBadBarChart.maxValue = chartManager.maxCheckInsCount
        goodBadBarChart.setupLayers()
    }
    
    func configureAppearance() {

        numbersView.configureAppearance()
        
        calendarSwitcher.contentView.backgroundColor = UIColor.backgroundColor
        calendarSwitcher.setupUI()
        
        progressChart.backgroundColor = UIColor.backgroundColor
        progressChart.setupLayers()
        
        goodBadBarChart.backgroundColor = UIColor.backgroundColor
        goodBadBarChart.setupLayers()
    }

}
extension StatisticContainer: CalendarSwitcherDelegate {
    
    func showPrevious(interval: CalendarInterval) {
        chartManager.intervalsBackwardFromNow += 1
        setupUI()
    }
    
    func showNext(interval: CalendarInterval) {
        chartManager.intervalsBackwardFromNow -= 1
        setupUI()
    }
    
    func switchTo(interval: CalendarInterval) {
        chartManager.intervalsBackwardFromNow = 0
        setupUI()
    }
}
