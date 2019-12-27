//
//  SubclassViewController.swift
//  SuperPowered
//
//  Created by Дарья Селезнёва on 17.12.2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

class GoalsMainViewController: GoalsBaseViewController {
    
    var addGoalButton = UIBarButtonItem()
    var filterButton = UIBarButtonItem()
    
    var isFilterShown: Bool = false
    
    var headerView = UIView()
    var headerHeightConstraint = NSLayoutConstraint()
    var filterView = FilterView()
    
    override var isEditMode: Bool {
        didSet {
            addGoalButton.isEnabled = !self.isEditMode
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emptyScreenLabel.text = "No goals set :( \n \n \n Tap \"+\" to create a goal"
       
        setupBarButtonItems()
        addGoalButton.isEnabled = defaults.bool(forKey: showActiveItemsKey)
        setupFilter()
        constrainTableViewTop(to: headerView, attribute: .bottom)
        
        navigationController?.navigationBar.barTintColor = UIColor.barBackgroundColor
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.textColor, NSAttributedString.Key.font : UIFont.headerFont!]
        
        navigationController?.tabBarController?.tabBar.barTintColor = UIColor.barBackgroundColor
        navigationController?.tabBarController?.tabBar.tintColor = UIColor.textColor
        
        defaults.addObserver(self, forKeyPath: showActiveItemsKey, options: .new, context: nil)
        defaults.addObserver(self, forKeyPath: showFinishedItemsKey, options: .new, context: nil)
        defaults.addObserver(self, forKeyPath: sortLatestFirstKey, options: .new, context: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        goals = goalsSorted()
        tableView.reloadData()
        isFilterShown = false
        headerHeightConstraint.constant = 0
        filterView.alpha =  0.0
    }
    
    // MARK: - Bar Button Items
    
    func setupBarButtonItems() {
        addGoalButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addGoalButtonPressed))
        navigationItem.rightBarButtonItem = addGoalButton
        addGoalButton.tintColor = UIColor.textColor
        filterButton = UIBarButtonItem(image: UIImage(named: "filter"), style: .plain, target: self, action: #selector(filterButtonPressed))
        filterButton.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: -10)
        navigationItem.leftBarButtonItem = filterButton
        filterButton.tintColor = UIColor.textColor
    }
    
    @objc func addGoalButtonPressed() {
        let index = latestFirst ? 0 : goals.filter { !$0.isFinished } .count
        goals.insert(Goal(title: "", description: "", color: Int.random(in: 1...19)), at: index)
        goals[index].validateID()
        goals[index].buffer()
        isEditMode = true
        tableView.insertSections(IndexSet(integer: index), with: .automatic)
        tableView.scrollToRow(at: IndexPath(row: 0, section: index), at: .bottom, animated: true)
    }
    
    @objc func filterButtonPressed() {
        isFilterShown = !isFilterShown
        headerHeightConstraint.constant = isFilterShown ? 110 : 0
        let alpha: CGFloat = isFilterShown ? 1.0 : 0.0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            self.filterView.alpha = alpha
        }
    }
    
    // MARK: - FilterView
    
    func setupFilter() {
        view.addSubview(headerView)
        let marginsGuide = view.layoutMarginsGuide
        headerView.constrainToEdges(of: view, leading: 0, trailing: 0, top: nil, bottom: nil)
        headerView.topAnchor.constraint(equalTo: marginsGuide.topAnchor).isActive = true
        headerHeightConstraint = headerView.heightAnchor.constraint(equalToConstant: 0)
        headerHeightConstraint.isActive = true
        headerView.backgroundColor = UIColor.backgroundColor
        headerView.addSubview(filterView)
        filterView.pinToEdges(to: headerView)
        filterView.setupUI()
        filterView.alpha = 0.0
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == sortLatestFirstKey {
            goals = goalsSorted()
        }
        tableView.reloadData()
        tableView.setNeedsDisplay()
        addGoalButton.isEnabled = defaults.bool(forKey: showActiveItemsKey) ? true : false
    }
}
