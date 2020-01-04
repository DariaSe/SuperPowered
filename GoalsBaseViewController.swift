//
//  GoalsBaseViewController.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 17.12.2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit
import CloudKit

class GoalsBaseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var dataManager = DataManager()
    
    var goals: [Goal] = [] {
        didSet {
            emptyScreenView.isHidden = !goals.isEmpty
            tableView.isHidden = goals.isEmpty
        }
    }
    
    var goal: Goal?
    
    var latestFirst: Bool {
        return defaults.bool(forKey: sortLatestFirstKey)
    }
    
    var isEditMode: Bool = false
    
    var selectedIndexPath: IndexPath?
    
    var tableViewTopConstraint = NSLayoutConstraint()
    var tableViewBottomConstraint = NSLayoutConstraint()
    
    var goalsTableViewContainer = GoalsTableViewContainer()
    var shadowingView = UIView()
    
    var tableView = UITableView()
    var emptyScreenView = UIView()
    var emptyScreenLabel = UILabel()
    
    // MARK: - Filtering and sorting
    
    func goalsSorted() -> [Goal] {
        let sortedActive = goals
            .filter{!$0.isFinished}
            .map{$0.withHabitsSorted()}
            .sorted(by: { latestFirst ? $0 > $1 : $0 < $1 })
        let sortedFinished = goals
            .filter{$0.isFinished}
            .map{$0.withHabitsSorted()}
            .sorted(by: { latestFirst ? $0 > $1 : $0 < $1 })
        return sortedActive + sortedFinished
    }
    
    var interfaceSource: [[MainItem]] { goals.map{$0.mainInterfaceArray}.filter{!$0.isEmpty}}
    
    func item(at indexPath: IndexPath) -> MainItem {
        return interfaceSource[indexPath.section][indexPath.row]
    }
    func itemIsGoal(at indexPath: IndexPath) -> Bool {
        return item(at: indexPath) is Goal
    }
    func itemIsHabit(at indexPath: IndexPath) -> Bool {
        return item(at: indexPath) is Habit
    }
    func itemIsAddItem(at indexPath: IndexPath) -> Bool {
        return item(at: indexPath) is AddItem
    }
    func itemWithID(id: UInt32) -> MainItem? {
        return interfaceSource.reduce([MainItem]()){$0 + $1}.filter{$0.id == id}.first
    }
    func goal(at indexPath: IndexPath) -> Goal? {
        return interfaceSource[indexPath.section][indexPath.row] as? Goal
    }
    func habit(at indexPath: IndexPath) -> Habit? {
        return interfaceSource[indexPath.section][indexPath.row] as? Habit
    }
    func indexPathForItem(with id: UInt32) -> IndexPath {
        var indexPath = IndexPath(row: 0, section: 0)
        for (section, array) in interfaceSource.enumerated() {
            for (row, item) in array.enumerated() {
                if item.id == id {
                    indexPath = IndexPath(row: row, section: section)
                }
            }
        }
        return indexPath
    }
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.backgroundColor
        setupEmptyScreenView()
        setupTableView()
        if let savedGoals = Goal.loadFromFile() {
            goals = savedGoals
        }
        else {
            goals = [Goal(title: "Sample goal", description: "Some fancy description", color: 1)]
        }
        if goals.isEmpty {
            goals = [Goal(title: "Sample goal", description: "Some fancy description", color: 1)]
            goals[0] = goals[0].withHabitAdded(habit: Habit(trigger: "Trigger", badHabit: "Bad", goodHabit: "Good", color: goals[0].color, goalID: goals[0].id, goalTitle: goals[0].title))
        }
        goals = goalsSorted()
        tableView.reloadData()
        
        registerForKeyboardNotifications()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refreshControl.tintColor = UIColor.textColor
        tableView.refreshControl = refreshControl
    }
    
    @objc func refresh() {
        fetchAndReload()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    func fetchAndReload() {
        self.dataManager.fetchAll { goals in
            self.goals = goals
            self.goals = self.goalsSorted()
            self.tableView.reloadData()
        }
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.constrainToEdges(of: view, leading: 0, trailing: 0, top: nil, bottom: nil)
        tableViewBottomConstraint = NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottomMargin, multiplier: 1, constant: 0)
        tableViewBottomConstraint.isActive = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.tableFooterView = UIView()
        
        tableView.register(UINib(nibName: "GoalTableViewCell", bundle: nil), forCellReuseIdentifier: "goalCell")
        tableView.register(UINib(nibName: "HabitTableViewCell", bundle: nil), forCellReuseIdentifier: "habitCell")
        tableView.register(AddNewHabitTableViewCell.self, forCellReuseIdentifier: AddNewHabitTableViewCell.reuseIdentifier)
        
        tableView.backgroundColor = UIColor.backgroundColor
        tableView.separatorColor = UIColor.linesColor
    }
    
    func constrainTableViewTop(to view: UIView, attribute: NSLayoutConstraint.Attribute) {
        tableViewTopConstraint = NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: view, attribute: attribute, multiplier: 1, constant: 0)
        tableViewTopConstraint.isActive = true
    }
    
    func setupEmptyScreenView() {
        view.addSubview(emptyScreenView)
        emptyScreenView.pinToEdges(to: view)
        emptyScreenView.backgroundColor = UIColor.backgroundColor
        emptyScreenView.addSubview(emptyScreenLabel)
        emptyScreenLabel.center(in: emptyScreenView)
        emptyScreenLabel.textColor = UIColor.placeholderTextColor
        emptyScreenLabel.numberOfLines = 5
        emptyScreenLabel.font = UIFont(name: montserratSemiBold, size: 16)
        emptyScreenLabel.textAlignment = .center
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let savedGoals = Goal.loadFromFile() {
            goals = savedGoals
        }
        tableView.reloadData()
    }
    // MARK: - Keyboard Notifications
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWasShown(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize!.height - (self.navigationController?.tabBarController?.tabBar.frame.height ?? 0), right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
        if let firstResponder = view.window?.firstResponder {
            if let indexPath = getCurrentCellIndexPath(view: firstResponder, in: tableView) {
                tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification) {
        tableView.contentInset = UIEdgeInsets.zero
        tableView.scrollIndicatorInsets = UIEdgeInsets.zero
        self.view.endEditing(true)
    }
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return interfaceSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interfaceSource[section].count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sourceItem = item(at: indexPath)
        switch sourceItem.itemType {
        case .goal(let goal):
            let cell = tableView.dequeueReusableCell(withIdentifier: "goalCell", for: indexPath) as! GoalTableViewCell
            cell.goal = goal
            cell.buttonsDelegate = self
            cell.saveDiscardDelegate = self
            cell.titleTextViewContainer.textChanged = { [weak tableView] text in
                tableView?.updateToFit(from: text, to: &goal.title)
            }
            cell.descriptionTextViewContainer.textChanged = { [weak tableView] text in
                tableView?.updateToFit(from: text, to: &goal.description)
            }
            return cell
            
        case .habit(let habit):
            let cell = tableView.dequeueReusableCell(withIdentifier: "habitCell", for: indexPath) as! HabitTableViewCell
            cell.habit = habit
            cell.goal = habit.goalTitle
            cell.saveDiscardDelegate = self
            cell.goalButtonDelegate = self
            cell.quickCheckInReceiver = self
            cell.cellActionsView.delegate = self
            cell.triggerTextViewContainer.textChanged = { [weak tableView] text in
                tableView?.updateToFit(from: text, to: &habit.trigger)
            }
            cell.badHabitTextViewContainer.textChanged = { [weak tableView] text in
                tableView?.updateToFit(from: text, to: &habit.badHabit)
            }
            cell.goodHabitTextViewContainer.textChanged = { [weak tableView] text in
                tableView?.updateToFit(from: text, to: &habit.goodHabit)
            }
            return cell
            
        case .addButton(let addItem):
            let cell = tableView.dequeueReusableCell(withIdentifier: AddNewHabitTableViewCell.reuseIdentifier, for: indexPath)
                as! AddNewHabitTableViewCell
            
            cell.color = UIColor.goalColor(index: addItem.color)
            return cell
        }
        
    }
    
    var cellHeights: [IndexPath : CGFloat] = [:]
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath] ?? 70.0
    }
    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        if isEditMode {
            return false
        }
        else {
            return itemIsGoal(at: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        guard let goal = goal(at: indexPath) else { return nil }
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            self.isEditMode = true
            goal.buffer()
            tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
        }
        edit.backgroundColor = UIColor.linesColor
        
        let delete = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            let alert = UIAlertController(title: "Warning!", message: "Do you really want to delete this goal?", preferredStyle: .alert)
            let yes = UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in
                self.goals = self.goals.filter { $0.id != goal.id }
                Goal.saveToFile(goals: self.goals)
                tableView.deleteSections(IndexSet(integer: indexPath.section), with: .fade)
                self.dataManager.delete(goal: goal)
            })
            let no = UIAlertAction(title: "No", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            })
            alert.addAction(no)
            alert.addAction(yes)
            
            self.present(alert, animated: true)
            
            Goal.saveToFile(goals: self.goals)
        }
        delete.backgroundColor = UIColor.AppColors.red
        return [delete, edit]
        
    }
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return !isEditMode
    }
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return isEditMode ? nil : indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if itemIsGoal(at: indexPath) {
            performSegue(withIdentifier: "showGoalSegue", sender: nil)
        }
            
        else if itemIsAddItem(at: indexPath) {
            isEditMode = true
            var newIndexPath = IndexPath()
            if var goal = goal {
                goal = goal.withHabitAdded(habit: nil)
                var newHabit = goal.habits[goal.newHabitIndex! - 1]
                newHabit.validateID()
                newIndexPath = IndexPath(
                    row: goal.newHabitIndex! - 1,
                    section: indexPath.section)
            }
            else {
                var goal = interfaceSource[indexPath.section][0] as! Goal
                goal = goal.withHabitAdded(habit: nil)
                var newHabit = goal.habits[goal.newHabitIndex! - 1]
                newHabit.validateID()
                newIndexPath = IndexPath(
                    row: goal.newHabitIndex!,
                    section: indexPath.section)
            }
            tableView.insertRows(at: [newIndexPath], with: .middle)
            tableView.scrollToRow(at: newIndexPath, at: .middle, animated: true)
        }
        else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let habitVC = storyboard.instantiateViewController(withIdentifier: "habitVC") as! HabitViewController
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            selectedIndexPath = indexPath
            if let habit = habit(at: indexPath) {
                habitVC.selectedHabitID = habit.id
            }
            self.navigationController?.pushViewController(habitVC, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func alertIfGoalIsFinished() {
        let finishedGoals = goals.filter{$0.isFinished && !$0.isFinishedConfirmationShown}
        if !finishedGoals.isEmpty {
            var goal = finishedGoals.first!
            goal.isFinishedConfirmationShown = true
            let alert = UIAlertController(title: "Goal \"\(goal.title)\" is achieved!", message: "Are there any more bad habits to beat?", preferredStyle: .alert)
            let addNewHabit = UIAlertAction(title: "Add new habit", style: .default) { (_) in
                self.isEditMode = true
                goal = goal.withHabitAdded(habit: nil)
                goal.isFinishedConfirmationShown = false
                Goal.saveToFile(goals: self.goals)
                let indexPath = IndexPath(row: goal.newHabitIndex!, section: self.indexPathForItem(with: goal.id).section)
                self.tableView.insertRows(at: [indexPath], with: .middle)
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
                self.goals = self.goalsSorted()
                self.tableView.reloadData()
                Goal.saveToFile(goals: self.goals)
            }
            alert.addAction(addNewHabit)
            alert.addAction(cancel)
            self.present(alert, animated: true)
        }
    }
    func setupGoalViewColor() {
        // method for goal controller
    }
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showGoalSegue" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            selectedIndexPath = indexPath
            let destinationGoal = goal(at: indexPath)
            let destinationVC = segue.destination as! GoalViewController
            destinationVC.goalID = destinationGoal?.id
        }
    }
}
// MARK: - Color Picker

extension GoalsBaseViewController: ColorPickerDelegate {
    func colorPicked(at index: Int) {
        // if used for main controller
        if goal == nil {
            for (offset, goal) in goals.enumerated() {
                if goal.bufferGoal != nil {
                    goal.color = index
                    self.tableView.reloadSections(IndexSet(integer: offset), with: .automatic)
                }
            }
        }
            // if used for goal controller
        else {
            goal!.color = index
            setupGoalViewColor()
            self.tableView.reloadData()
        }
    }
}


// MARK: - GoalCellButtonsDelegate

extension GoalsBaseViewController: GoalCellButtonsDelegate {
    func showHideButtonPressed(sender: UIButton) {
        if let indexPath = getCurrentCellIndexPath(view: sender, in: tableView) {
            if let goal = goal(at: indexPath) {
                goal.isCollapsed = !goal.isCollapsed
                Goal.saveToFile(goals: goals)
                tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
            }
        }
    }
    
    func colorPickerButtonPressed(sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let colorPickerVC = storyboard.instantiateViewController(withIdentifier: "colorPickerVC") as! ColorPickerViewController
        colorPickerVC.delegate = self
        colorPickerVC.modalPresentationStyle = .overCurrentContext
        colorPickerVC.view.backgroundColor = UIColor.backgroundCompanionColor.withAlphaComponent(0.6)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.present(colorPickerVC, animated: true)
        }
    }
}

// MARK: - SaveDiscardDelegate

extension GoalsBaseViewController: CellSaveDiscardDelegate {
    func saveChanges(cell: UITableViewCell) {
        tableView.isScrollEnabled = true
        if let indexPath = tableView.indexPath(for: cell) {
            if let goal = goal(at: indexPath) {
                goal.saveChanges()
                tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
                dataManager.save(goal: goal)
                for habit in goal.habits {
                    dataManager.save(habit: habit)
                }
            }
            if let habit = habit(at: indexPath) {
                // if goalScreen
                var goalToModify: Goal
                if let goal = goal {
                    goalToModify = goal
                }
                    // if mainScreen
                else {
                    goalToModify = goal(at: IndexPath(row: 0, section: indexPath.section))!
                }
                if habit.goalID != goalToModify.id {
                    habit.isEditMode = false
                    goalToModify = goalToModify.withHabitRemoved(habit: habit)
                    var destinationGoal = goals.filter{$0.id == habit.goalID}.first!
                    destinationGoal = destinationGoal.withHabitAdded(habit: habit)
                    tableView.reloadData()
                }
                else {
                    habit.isEditMode = false
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                }
                dataManager.save(habit: habit)
            }
        }
        for goal in goals {
            goal.isSelected = false
        }
        isEditMode = false
        Goal.saveToFile(goals: goals)
    }
    
    func discardChanges(cell: UITableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            if let goal = goal(at: indexPath) {
                if goal.bufferGoal?.title == "" {
                    goals = goals.filter { $0.id != goal.id }
                    tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
                }
                else {
                    goal.restoreFromBuffer()
                    tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
                }
            }
            else if let habit = habit(at: indexPath) {
                if habit.bufferHabit != nil {
                    habit.restoreFromBuffer()
                    habit.bufferHabit = nil
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                }
                else {
                    if let goal = goal {
                        goal.habits = goal.habits.filter{$0.id != habit.id}
                    }
                    else {
                        let sourceGoal = goal(at: IndexPath(row: 0, section: indexPath.section))!
                        sourceGoal.habits = sourceGoal.habits.filter{$0.id != habit.id}
                    }
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        }
        Goal.saveToFile(goals: goals)
        isEditMode = false
        for goal in goals {
            goal.isSelected = false
        }
    }
}

// MARK: - QuickCheckInReceiver

extension GoalsBaseViewController: QuickCheckInReceiver {
    func addBadCheckIn(cell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        if var habit = habit(at: indexPath) {
            habit = habit.withCheckInAdded(habitType: .bad)
            Goal.saveToFile(goals: goals)
            let checkIn = habit.checkIns[0]
            dataManager.save(checkIn: checkIn)
            if let alert = habit.alertFailed() {
                self.present(alert, animated: true)
            }
        }
    }
    
    func addGoodCheckIn(cell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        if var habit = habit(at: indexPath) {
            habit = habit.withCheckInAdded(habitType: .good)
            Goal.saveToFile(goals: goals)
            let checkIn = habit.checkIns[0]
            dataManager.save(checkIn: checkIn)
            if let alert = habit.alertFinished(handler: nil) {
                self.present(alert, animated: true) {
                    self.dismiss(animated: true) {
                        self.tableView.reloadRows(at: [indexPath], with: .none)
                        self.alertIfGoalIsFinished()
                    }
                }
            }
        }
    }
    
    func cancelLastCheckIn(cell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        if var habit = habit(at: indexPath) {
            let checkIn = habit.checkIns[0]
            dataManager.delete(checkIn: checkIn)
            habit = habit.withLastCheckInCancelled()
            Goal.saveToFile(goals: goals)
        }
    }
    
    func reload(cell: UITableViewCell) {
        Goal.saveToFile(goals: goals)
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
}
// MARK: - CellActionsDelegate

extension GoalsBaseViewController: CellActionsDelegate {
    func addNote(sender: UIButton) {
        if let indexPath = getCurrentCellIndexPath(view: sender, in: tableView) {
            selectedIndexPath = indexPath
            //            let feedController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeedTableVC") as! FeedTableViewController
            let feedController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "journalVC") as! HabitJournalViewController
            if let habit = habit(at: indexPath) {
                feedController.historyTableViewContainer.feedItems = habit.journalInterfaceArray
                feedController.color = habit.color
                feedController.historyTableViewContainer.delegate = self
            }
            self.present(feedController, animated: true)
        }
    }
    
    func edit(sender: UIButton) {
        isEditMode = true
        if let indexPath = getCurrentCellIndexPath(view: sender, in: tableView) {
            if let goal = goal(at: indexPath) {
                goal.buffer()
                tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
            }
            if let habit = habit(at: indexPath) {
                habit.isEditMode = true
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    func restart(sender: UIButton) {
        if let indexPath = getCurrentCellIndexPath(view: sender, in: tableView) {
            let alert = UIAlertController(title: "Do you want to restart this habit?", message: "All achievements and progress will be deleted.", preferredStyle: .alert)
            let restart = UIAlertAction(title: "Restart", style: .destructive) { (_) in
                if let habit = self.habit(at: indexPath) {
                    habit.checkIns.removeAll()
                    let goal = self.goals.filter{$0.hasItemWithID(id: habit.id)}.first!
                    goal.isFinishedConfirmationShown = false
                    Goal.saveToFile(goals: self.goals)
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
            let cancel = UIAlertAction(title: "Cancel", style: .default) { (_) in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(cancel)
            alert.addAction(restart)
            self.present(alert, animated: true)
        }
    }
    
    func delete(sender: UIButton) {
        if let indexPath = getCurrentCellIndexPath(view: sender, in: tableView) {
            let alert = UIAlertController(title: "Do you want to delete this habit?", message: "All achievements, progress and notes will also be deleted.", preferredStyle: .alert)
            let delete = UIAlertAction(title: "Delete", style: .destructive) { (_) in
                if let habit = self.habit(at: indexPath) {
                    let goal = self.goals.filter{$0.hasItemWithID(id: habit.id)}.first!
                    goal.habits = goal.habits.filter{$0.id != habit.id}
                    Goal.saveToFile(goals: self.goals)
                    self.dataManager.delete(habit: habit)
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
            let cancel = UIAlertAction(title: "Cancel", style: .default) { (_) in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(cancel)
            alert.addAction(delete)
            
            self.present(alert, animated: true)
        }
    }
}
// MARK: - GoalButtonDelegate

extension GoalsBaseViewController: GoalButtonDelegate {
    func showGoals(sender: UIButton) {
        guard let indexPath = getCurrentCellIndexPath(view: sender, in: tableView) else { return }
        selectedIndexPath = indexPath
        tableView.isScrollEnabled = false
        self.view.addSubview(shadowingView)
        shadowingView.frame = self.view.frame
        shadowingView.backgroundColor = UIColor.backgroundColor
        shadowingView.alpha = 0.4
        shadowingView.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissGoals))
        shadowingView.addGestureRecognizer(tapRecognizer)
        let selectedGoals = goals.filter{$0.isSelected}
        if selectedGoals.count == 0 {
            let goalToSelect = goal(at: indexPath)
            goalToSelect?.isSelected = true
        }
        let senderOrigin = sender.convert(CGPoint.zero, to: self.view)
        let senderHeight = sender.frame.height
        self.view.addSubview(goalsTableViewContainer)
        goalsTableViewContainer.tableView.backgroundColor = UIColor.backgroundColor
        goalsTableViewContainer.layer.borderColor = UIColor.backgroundCompanionColor.withAlphaComponent(0.3).cgColor
        goalsTableViewContainer.delegate = self
        goalsTableViewContainer.goals = goals
        let goalsTableViewHeight = CGFloat(goals.count * 44)
        if senderOrigin.y > tableView.center.y {
            goalsTableViewContainer.frame = CGRect(x: senderOrigin.x, y: senderOrigin.y - goalsTableViewHeight, width: sender.frame.width, height: goalsTableViewHeight)
        }
        else {
            goalsTableViewContainer.frame = CGRect(x: senderOrigin.x, y: senderOrigin.y + senderHeight, width: sender.frame.width, height: goalsTableViewHeight)
        }
    }
    
    @objc func dismissGoals() {
        shadowingView.removeFromSuperview()
        goalsTableViewContainer.removeFromSuperview()
        tableView.isScrollEnabled = true
    }
}

// MARK: - GoalsTableViewDelegate

extension GoalsBaseViewController: GoalsTableViewDelegate {
    func goalSelected(id: UInt32) {
        guard let selectedIndexPath = selectedIndexPath else { return }
        if let habitToChange = habit(at: selectedIndexPath) {
            let selectedGoal = goals.filter{$0.id == id}.first!
            habitToChange.color = selectedGoal.color
            habitToChange.goalTitle = selectedGoal.title
            habitToChange.goalID = selectedGoal.id
            tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
            for goal in goals {
                goal.isSelected = goal.id == id
            }
        }
    }
}

// MARK: - FeedTableViewControllerDelegate

extension GoalsBaseViewController: FeedDelegate {
    func addNote(note: Note) {
        guard let selectedIndexPath = selectedIndexPath,
            let habit = habit(at: selectedIndexPath) else { return }
        note.id = habit.id
        note.triggerText = habit.trigger
        habit.notes.insert(note, at: 0)
        habit.notes[0].validateID()
        Goal.saveToFile(goals: goals)
    }
    func reload() {
        tableView.reloadData()
    }
}
