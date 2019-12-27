//
//  FeedTableViewController.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 11/10/2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

class FeedTableViewController: UITableViewController, UIGestureRecognizerDelegate {
    
    var feedItemsManager = FeedDatesManager()
    
    var feedItems: [FeedItem] = [] {
        didSet {
            feedItemsManager.feedItems = self.feedItems
            feedItemsDivided = feedItemsManager.feedItemsDivided
//            emptyScreenView.isHidden = !feedItems.isEmpty
//            tableView.isHidden = feedItems.isEmpty
        }
    }
    var feedItemsDivided: [[FeedItem]] = [[]]
    
    func item(at indexPath: IndexPath) -> FeedItem {
        return feedItemsDivided[indexPath.section][indexPath.row]
    }
    
    var dateStrings: [String] { feedItemsManager.dateSignatures }
    
    var bufferedFeedItem: FeedItem? {
        didSet {
            addButton.isEnabled = self.bufferedFeedItem == nil ? true : false
        }
    }
    
    var color: Int?
    
    var delegate: FeedDelegate?
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var addButton: UIButton!
    @IBAction func addButtonPressed(_ sender: UIButton) {
        addButton.isEnabled = false
        feedItems.insert(FeedItem(triggerText: "", text: "", date: Date(), type: .note, id: arc4random(), color: color), at: 0)
        feedItems[0].isEditMode = true
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        if let indexPaths = tableView.indexPathsForVisibleRows {
            tableView.reloadRows(at: indexPaths, with: .automatic)
        }
    }
    
    @IBOutlet weak var dismissButton: UIButton!
    @IBAction func dismissButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if feedItems[0].text == "" {
            feedItems[0].isEditMode = true
        }
        addButton.isEnabled = false
        dismissButton.setTintedImage(imageNamed: "Wide Arrow Down", tintColor: UIColor.linesColor, for: .normal)
        dismissButton.showsTouchWhenHighlighted = true
        self.view.backgroundColor = UIColor.backgroundColor
        tableView.register(UINib(nibName: "FeedTableViewCell", bundle: nil), forCellReuseIdentifier: "FeedTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 90
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .none
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(pulledDown(recognizer:)))
        panGestureRecognizer.delegate = self
        self.tableView.addGestureRecognizer(panGestureRecognizer)
        
        let timer = Timer(timeInterval: 5.0, target: self, selector: #selector(refresh), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: RunLoop.Mode.default)
    }
    
    @objc func refresh() {
        guard !feedItems.isEmpty else { return }
        if bufferedFeedItem == nil && !feedItems[0].isEditMode {
            tableView.reloadData()
        }
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return feedItemsDivided.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return feedItemsDivided[section].count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell", for: indexPath) as! FeedTableViewCell
        let feedItem = item(at: indexPath)
        cell.displaysTrigger = false
        cell.update(with: feedItem)
        cell.saveDiscardDelegate = self
        //        cell.verticalLineAboveCircle.color = indexPath.row == 0 ? .clear : .dottedLineColor
        let isLast = (indexPath.section == feedItemsDivided.count - 1) && (indexPath.row == (feedItemsDivided.last?.count ?? 0) - 1)
        cell.verticalLineUnderCircle.color = isLast ? .clear : .dottedLineColor
        
        cell.textViewContainer.textChanged = { [weak tableView] text in
            tableView?.updateToFit(from: text, to: &self.feedItemsDivided[indexPath.section][indexPath.row].text)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = FeedSectionHeaderView()
        headerView.setupText(text: dateStrings[section])
        if section == 0 {
            headerView.verticalLineAboveCircle.color = .clear
        }
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if item(at: indexPath).type == .note {
            return !item(at: indexPath).isEditMode
        }
        else {
            return false
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if item(at: indexPath).type == .note {
            return item(at: indexPath).isEditMode ? nil : indexPath
        }
        else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard item(at: indexPath).type == .note &&
            !item(at: indexPath).isEditMode else { return }
        feedItemsDivided[indexPath.section][indexPath.row].isExpanded = !feedItemsDivided[indexPath.section][indexPath.row].isExpanded
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        var hasEditingItem = false
        for feedItem in feedItems {
            if feedItem.isEditMode == true {
                hasEditingItem = true
            }
        }
        return !hasEditingItem
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .default, title: "Edit") { (action, indexPath) in
            self.bufferedFeedItem = self.item(at: indexPath)
            self.feedItemsDivided[indexPath.section][indexPath.row].isEditMode = true
            if let indexPaths = tableView.indexPathsForVisibleRows {
                tableView.reloadRows(at: indexPaths, with: .automatic)
            }
        }
        edit.backgroundColor = UIColor.AppColors.backgroundCompanionColor
        
        let delete = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            self.delegate?.deleteItem(with: self.item(at: indexPath).id)
            self.delegate?.reload()
            self.feedItemsDivided[indexPath.section].remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            if let indexPaths = tableView.indexPathsForVisibleRows {
                tableView.reloadRows(at: indexPaths, with: .automatic)
            }
        }
        delete.backgroundColor = UIColor.AppColors.red
        return [delete, edit]
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func pulledDown(recognizer: UIPanGestureRecognizer) {
        let panOffset = recognizer.translation(in: tableView)
        if panOffset.y > 300 {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension FeedTableViewController: CellSaveDiscardDelegate {
    func saveChanges(cell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        if bufferedFeedItem == nil {
            feedItems[0].creationDate = Date()
            let newNote = Note.from(feedItem: feedItems[0])
            delegate?.addNote(note: newNote)
            feedItems[0].isEditMode = false
        }
        else {
            let editedFeedItem = item(at: indexPath)
            delegate?.editItemText(replaceWith: editedFeedItem.text, id: editedFeedItem.id)
            feedItemsDivided[indexPath.section][indexPath.row].isEditMode = false
        }
        if let indexPaths = tableView.indexPathsForVisibleRows {
            tableView.reloadRows(at: indexPaths, with: .automatic)
        }
        bufferedFeedItem = nil
    }
    
    func discardChanges(cell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        if let bufferedFeedItem = bufferedFeedItem {
            feedItemsDivided[indexPath.section][indexPath.row] = bufferedFeedItem
            if let indexPaths = tableView.indexPathsForVisibleRows {
                tableView.reloadRows(at: indexPaths, with: .automatic)
            }
        }
        else {
            if feedItemsDivided.first!.count != 1 {
                feedItems.removeFirst()
                tableView.deleteRows(at: [indexPath], with: .automatic)
                if let indexPaths = tableView.indexPathsForVisibleRows {
                    tableView.reloadRows(at: indexPaths, with: .automatic)
                }
            }
            else {
                feedItems.removeFirst()
                tableView.deleteSections(IndexSet(integer: 0), with: .automatic)
            }
        }
        bufferedFeedItem = nil
    }
}
