//
//  HistoryTableViewContainer.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 29.11.2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

class HistoryTableViewContainer: UIView {
    
    //MARK: - Properties
    
    var feedItemsManager = FeedDatesManager()
    
    var feedItems: [FeedItem] = [] {
        didSet {
            feedItemsManager.feedItems = self.feedItems
            feedItemsDivided = feedItemsManager.feedItemsDivided
            emptyScreenView.isHidden = !feedItems.isEmpty
            tableView.isHidden = feedItems.isEmpty
        }
    }
    var feedItemsDivided: [[FeedItem]] = [[]]
    
    func item(at indexPath: IndexPath) -> FeedItem {
        return feedItemsDivided[indexPath.section][indexPath.row]
    }
    
    var dateStrings: [String] { feedItemsManager.dateSignatures }
    
    var bufferedFeedItem: FeedItem?
    
    var delegate: FeedDelegate?
    
    var displaysTrigger: Bool = true
    
    var isEditMode: Bool = false
    
    var showsFilter: Bool = true
    
    
    let filterView = HistoryFilterView()
    var filterViewTopConstraint = NSLayoutConstraint()
    
    let tableView = UITableView(frame: CGRect.zero, style: .grouped)
    var tableViewBottomConstraint = NSLayoutConstraint()
    
    var emptyScreenView = UIView()
    var emptyScreenLabel = UILabel()
    
    let imageView = UIView()
    
    //MARK: - Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    func commonInit() {
        clipsToBounds = true
        setupEmptyScreenView()
        self.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.backgroundColor = UIColor(patternImage: UIImage(named: "schemeGreen")!.withRenderingMode(.alwaysTemplate))
//        imageView.image = UIImage(named: "scheme400")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.AppColors.green.withAlphaComponent(0.1)
   
        self.addSubview(filterView)
        filterView.constrainToEdges(of: self, leading: 0, trailing: 0, top: nil, bottom: nil)
        filterViewTopConstraint = filterView.topAnchor.constraint(equalTo: self.topAnchor)
        filterViewTopConstraint.isActive = true
        filterView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.addSubview(tableView)
        tableView.constrainToEdges(of: self, leading: 0, trailing: 0, top: nil, bottom: nil)
        tableView.topAnchor.constraint(equalTo: filterView.bottomAnchor).isActive = true
        tableViewBottomConstraint = tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        tableViewBottomConstraint.isActive = true
        
        self.backgroundColor = .clear
        tableView.register(UINib(nibName: "FeedTableViewCell", bundle: nil), forCellReuseIdentifier: "FeedTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 90
        tableView.dataSource = self
        tableView.delegate = self
        registerForKeyboardNotifications()
        let timer = Timer(timeInterval: 5.0, target: self, selector: #selector(refresh), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: RunLoop.Mode.default)
        
    }
    
    func setupEmptyScreenView() {
        self.addSubview(emptyScreenView)
        emptyScreenView.pinToEdges(to: self)
        emptyScreenView.backgroundColor = UIColor.backgroundColor
        emptyScreenView.addSubview(emptyScreenLabel)
        emptyScreenLabel.center(in: emptyScreenView)
        emptyScreenLabel.textColor = UIColor.placeholderTextColor
        emptyScreenLabel.numberOfLines = 7
        emptyScreenLabel.font = UIFont(name: montserratSemiBold, size: 16)
        emptyScreenLabel.textAlignment = .center
        emptyScreenLabel.text = "Here will be shown \n \n your right decisions and setbacks, \n \n your thoughts and insights."
    }
    
    @objc func refresh() {
        if !isEditMode {
            tableView.reloadData()
        }
    }
    
    func setupFilter(notes: Bool, bad: Bool, good: Bool) {
        filterView.showNotes = notes
        filterView.showBadHabits = bad
        filterView.showGoodHabits = good
        filterView.setupUI()
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWasShown(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        let tabBarHeight: CGFloat = showsFilter ? 30 : 0
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize!.height - tabBarHeight, right: 0)
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize!.height - tabBarHeight, right: 0)
        
        if let firstResponder = self.window?.firstResponder {
            if let indexPath = getCurrentCellIndexPath(view: firstResponder, in: tableView) {
                tableView.scrollToRow(at: indexPath, at: .none, animated: true)
            }
        }
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification) {
        tableView.contentInset = UIEdgeInsets.zero
        tableView.scrollIndicatorInsets = UIEdgeInsets.zero
        self.endEditing(true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard showsFilter else { return }
        let translation = scrollView.panGestureRecognizer.translation(in: self).y
        
        if translation < 0 && filterViewTopConstraint.constant != -50 {
            filterViewTopConstraint.constant = -50
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            }
            scrollView.panGestureRecognizer.setTranslation(CGPoint.zero, in: self)
        }
        else if translation > 0 && filterViewTopConstraint.constant != 0 {
            filterViewTopConstraint.constant = 0
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            }
            scrollView.panGestureRecognizer.setTranslation(CGPoint.zero, in: self)
            
        }
        
    }
    
}
extension HistoryTableViewContainer: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return feedItemsDivided.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedItemsDivided[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell", for: indexPath) as! FeedTableViewCell
        let feedItem = item(at: indexPath)
        cell.displaysTrigger = displaysTrigger
        cell.update(with: feedItem)
        cell.saveDiscardDelegate = self
        cell.backgroundColor = .clear
        cell.textViewContainer.textChanged = { [weak tableView] text in
            tableView?.updateToFit(from: text, to: &self.feedItemsDivided[indexPath.section][indexPath.row].text)
            //            cell.verticalLineUnderCircle.setNeedsDisplay()
        }
        let isLast = indexPath.row == feedItemsDivided[indexPath.section].count - 1
        cell.verticalLineUnderCircle.color = isLast ? .clear : .dottedLineColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = FeedSectionHeaderView()
        if !feedItems.isEmpty {
            headerView.setupText(text: dateStrings[section])
//            if section == 0 {
                headerView.verticalLineAboveCircle.color = .clear
//            }
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
}

extension HistoryTableViewContainer: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if item(at: indexPath).type == .note {
            return !item(at: indexPath).isEditMode
        }
        else {
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard !isEditMode else { return nil }
        if item(at: indexPath).type == .note {
            return item(at: indexPath).isEditMode ? nil : indexPath
        }
        else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard item(at: indexPath).type == .note &&
            !item(at: indexPath).isEditMode && !isEditMode else { return }
        feedItemsDivided[indexPath.section][indexPath.row].isExpanded = !feedItemsDivided[indexPath.section][indexPath.row].isExpanded
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return !isEditMode
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .default, title: "Edit") { (action, indexPath) in
            self.bufferedFeedItem = self.item(at: indexPath)
            self.feedItemsDivided[indexPath.section][indexPath.row].isEditMode = true
            if let indexPaths = tableView.indexPathsForVisibleRows {
                tableView.reloadRows(at: indexPaths, with: .automatic)
            }
            self.isEditMode = true
        }
        edit.backgroundColor = UIColor.AppColors.backgroundCompanionColor
        
        let delete = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            if self.feedItems.count != 1 {
                let itemToRemove = self.feedItemsDivided[indexPath.section].remove(at: indexPath.row)
                self.delegate?.deleteItem(with: itemToRemove.id)
                self.feedItems = self.feedItems.filter{$0.id != itemToRemove.id}
                tableView.deleteRows(at: [indexPath], with: .automatic)
                if let indexPaths = tableView.indexPathsForVisibleRows {
                    tableView.reloadRows(at: indexPaths, with: .automatic)
                }
            }
            else {
                let itemToRemove = self.feedItemsDivided[0].remove(at: 0)
                self.delegate?.deleteItem(with: itemToRemove.id)
                self.feedItems = self.feedItems.filter{$0.id != itemToRemove.id}
                tableView.deleteSections(IndexSet(integer: 0), with: .automatic)
            }
//            let itemToRemove = self.feedItemsDivided[indexPath.section].remove(at: indexPath.row)
//            self.delegate?.deleteItem(with: itemToRemove.id)
//            self.feedItems = self.feedItems.filter{$0.id != itemToRemove.id}
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//            if let indexPaths = tableView.indexPathsForVisibleRows {
//                tableView.reloadRows(at: indexPaths, with: .automatic)
//            }
        }
        delete.backgroundColor = UIColor.AppColors.red
        return [delete, edit]
    }
}

extension HistoryTableViewContainer: CellSaveDiscardDelegate {
    func saveChanges(cell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        if bufferedFeedItem == nil {
            var item = feedItemsDivided[0][0]
            item.creationDate = Date()
            let newNote = Note.from(feedItem: item)
            delegate?.addNote(note: newNote)
            item.isEditMode = false
            feedItems = feedItems.map{$0.id == item.id ? item : $0}
        }
        else {
            var editedItem = item(at: indexPath)
            let text = editedItem.text
            delegate?.editItemText(replaceWith: text, id: editedItem.id)
            editedItem.isEditMode = false
            feedItems = feedItems.map{$0.id == editedItem.id ? editedItem : $0}
        }
        
        if let indexPaths = tableView.indexPathsForVisibleRows {
            tableView.reloadRows(at: indexPaths, with: .automatic)
        }
        bufferedFeedItem = nil
        isEditMode = false
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "enableAddButton"), object: nil)
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
        isEditMode = false
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "enableAddButton"), object: nil)
    }
}
