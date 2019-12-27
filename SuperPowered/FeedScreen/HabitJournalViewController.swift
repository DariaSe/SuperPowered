//
//  HabitJournalViewController.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 21.12.2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

class HabitJournalViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var feedItems: [FeedItem] = []
    
    var headerView = UIView()
    var dismissButton = UIButton()
    var addButton = UIButton()
    
    var historyTableViewContainer = HistoryTableViewContainer()
    
    var color: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.backgroundColor
        setupHeader()
        setupTableViewContainer()
        addButton.isEnabled = false
        NotificationCenter.default.addObserver(self, selector: #selector(enableAddButton), name: NSNotification.Name("enableAddButton"), object: nil)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(pulledDown(recognizer:)))
        panGestureRecognizer.delegate = self
        view.addGestureRecognizer(panGestureRecognizer)
    }
    @objc func enableAddButton() {
        addButton.isEnabled = true
    }
    func setupHeader() {
        let marginsGuide = view.layoutMarginsGuide
        view.addSubview(headerView)
        headerView.constrainToEdges(of: view, leading: 0, trailing: 0, top: nil, bottom: nil)
        headerView.topAnchor.constraint(equalTo: marginsGuide.topAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        headerView.addSubview(dismissButton)
        dismissButton.center(in: headerView)
        dismissButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        dismissButton.setTintedImage(imageNamed: "Wide Arrow Down", tintColor: UIColor.linesColor, for: .normal)
        dismissButton.contentMode = .scaleToFill
        dismissButton.showsTouchWhenHighlighted = true
        dismissButton.addTarget(self, action: #selector(dismissButtonPressed), for: .touchUpInside)
        
        headerView.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -10).isActive = true
        addButton.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 10).isActive = true
        addButton.setTitle("+ Add a note", for: .normal)
        addButton.titleLabel?.font = UIFont(name: montserratSemiBold, size: 14)
        addButton.setTitleColor(UIColor.textColor, for: .normal)
        addButton.setTitleColor(UIColor.placeholderTextColor, for: .disabled)
        addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
    }
    
    @objc func dismissButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func addButtonPressed() {
        addButton.isEnabled = false
        historyTableViewContainer.feedItems.insert(FeedItem(triggerText: "", text: "", date: Date(), type: .note, id: arc4random(), color: color), at: 0)
        historyTableViewContainer.feedItems[0].isEditMode = true
        if historyTableViewContainer.tableView.numberOfSections == 0 {
            historyTableViewContainer.tableView.insertSections(IndexSet(integer: 0), with: .automatic)
        }
        else {
        historyTableViewContainer.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        }
        if let indexPaths = historyTableViewContainer.tableView.indexPathsForVisibleRows {
            historyTableViewContainer.tableView.reloadRows(at: indexPaths, with: .automatic)
        }
        historyTableViewContainer.isEditMode = true
    }
    
    func setupTableViewContainer() {
        view.addSubview(historyTableViewContainer)
        historyTableViewContainer.constrainToEdges(of: view, leading: 0, trailing: 0, top: nil, bottom: 0)
        historyTableViewContainer.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        historyTableViewContainer.tableView.backgroundColor = .clear
        historyTableViewContainer.tableView.separatorColor = .clear
        historyTableViewContainer.isEditMode = true
        historyTableViewContainer.showsFilter = false
        historyTableViewContainer.filterViewTopConstraint.constant = -50
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func pulledDown(recognizer: UIPanGestureRecognizer) {
        let panOffset = recognizer.translation(in: view)
        if panOffset.y > 300 {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
