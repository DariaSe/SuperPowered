//
//  ViewController.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 02/10/2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

protocol HabitScreenDelegate {
    func habitChanged(habit: Habit)
}

class HabitViewController: UIViewController {
    
    var selectedHabitID: UInt32?
    
    var goals: [Goal] = []
    
    var habit: Habit?
    
    var isEditMode: Bool = false {
        didSet {
            editButton.isEnabled = !isEditMode
            habitSceneView.habit = habit
            habitSceneView.isEditMode = isEditMode
            statisticsContainer.isHidden = isEditMode
            toFeedScreenButton.isHidden = isEditMode
            habitSceneView.updateSelector(with: goals)
            if isEditMode {
                habitSceneTopConstraint.isActive = false
                habitSceneBottomConstraint.isActive = false
                habitSceneCenterConstraint.isActive = true
            }
            else {
                habitSceneCenterConstraint.isActive = false
                habitSceneTopConstraint.isActive = true
                habitSceneBottomConstraint.isActive = true
            }
        }
    }
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBAction func editButtonPressed(_ sender: Any) {
        isEditMode = true
    }
    
    
    
    @IBOutlet weak var habitSceneView: HabitScene!
    
    @IBOutlet weak var habitSceneCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var habitSceneTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var habitSceneBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var statisticsContainer: StatisticContainer!
    
    @IBOutlet weak var toFeedScreenButton: UIButton!
    @IBAction func toFeedScreenButtonPressed(_ sender: UIButton) {
        showJournal()
    }
    
    var delegate: HabitScreenDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.backgroundColor
        navigationController?.navigationBar.tintColor = UIColor.textColor
        navigationController?.navigationBar.barTintColor = UIColor.barBackgroundColor
        
        habitSceneView.backgroundColor = .clear
        habitSceneView.delegate = self
        habitSceneView.cancelDoneButtonsView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let savedGoals = Goal.loadFromFile() {
            goals = savedGoals
        }
        if let id = selectedHabitID {
            habit = goals.filter{$0.hasItemWithID(id: id)}.map{$0.habitWithID(id: id)}.first!
        }
        habitSceneView.habit = habit
        configureStatistics()
        configureToFeedScreenButton()
        editButton.isEnabled = true
    }
    
    func configureToFeedScreenButton() {
        toFeedScreenButton.setTitle(" + Add a note...", for: .normal)
        toFeedScreenButton.setTitleColor(UIColor.textColor, for: .normal)
        toFeedScreenButton.titleLabel?.font = UIFont(name: montserratSemiBold, size: UIFont.triggerFontSize)
        toFeedScreenButton.backgroundColor = UIColor.backgroundCompanionColor
    }
    
    func configureStatistics() {
        statisticsContainer.chartManager.habit = habit
        statisticsContainer.configureAppearance()
        statisticsContainer.statisticsItems = habit?.statisticsItems ?? []
        statisticsContainer.setupUI()
    }
    
    
    func showJournal() {
        guard let habit = habit else { return }
        let journalVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "journalVC") as! HabitJournalViewController
        journalVC.historyTableViewContainer.feedItems = habit.journalInterfaceArray
        journalVC.color = habit.color
        journalVC.historyTableViewContainer.delegate = self
        self.present(journalVC, animated: true)
    }
    
    
    func configureAndSaveChanges() {
        habitSceneView.habit = habit
        configureStatistics()
        var goal = goals.filter{$0.hasItemWithID(id: selectedHabitID!)}.first!
        goal = goal.withHabitChanged(habit: habit!)
        goals = goals.map{$0.id == goal.id ? goal : $0}
        Goal.saveToFile(goals: goals)
    }
}

extension HabitViewController: HabitSceneDelegate {
    
    func addGoodCheckIn() {
        habit = habit?.withCheckInAdded(habitType: .good)
        configureAndSaveChanges()
        if let alert = habit?.alertFinished(handler: { (_) in
            self.navigationController?.popToRootViewController(animated: true)
        }) {
            self.present(alert, animated: true)
        }
    }
    
    func addBadCheckIn() {
        habit = habit?.withCheckInAdded(habitType: .bad)
        configureAndSaveChanges()
        if let alert = habit?.alertFailed() {
            self.present(alert, animated: true)
        }
    }
    
    func cancelCheckIn() {
        habit = habit?.withLastCheckInCancelled()
        configureAndSaveChanges()
    }
    
    func updateGoalButton(goalID: UInt32) {
        let goal = goals.filter{$0.id == goalID}.first!
        habitSceneView.updateGoalButton(with: goal)
    }
    
    func restart() {
        let alert = UIAlertController(title: "Do you want to restart this habit?", message: "All achievements and progress will be deleted.", preferredStyle: .alert)
        let restart = UIAlertAction(title: "Restart", style: .destructive) { (_) in
            guard let habit = self.habit else { return }
            self.habitSceneView.batteriesView.restart()
            habit.checkIns.removeAll()
            self.goals = self.goals.map{$0.hasItemWithID(id: habit.id) ? $0.withHabitChanged(habit: habit) : $0}
            Goal.saveToFile(goals: self.goals)
            self.isEditMode = false
            self.habitSceneView.habit = self.habit
            self.configureStatistics()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancel)
        alert.addAction(restart)
        self.present(alert, animated: true)
    }
    
    func delete() {
        let alert = UIAlertController(title: "Do you want to delete this habit?", message: "All achievements and progress will be deleted.", preferredStyle: .alert)
        let restart = UIAlertAction(title: "Delete", style: .destructive) { (_) in
            guard let habit = self.habit else { return }
            self.goals = self.goals.map{$0.hasItemWithID(id: habit.id) ? $0.withHabitRemoved(habit: habit) : $0}
            Goal.saveToFile(goals: self.goals)
            self.navigationController?.popToRootViewController(animated: true)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancel)
        alert.addAction(restart)
        self.present(alert, animated: true)
    }
}
extension HabitViewController: FeedDelegate {
    
    func addNote(note: Note) {
        guard let habit = habit else { return }
        note.triggerText = habit.trigger
        habit.notes.insert(note, at: 0)
        configureAndSaveChanges()
    }
    
    func editItemText(replaceWith text: String, id: UInt32) {
        guard var habit = habit else { return }
        habit = habit.withItemChanged(replaceWith: text, itemWith: id)
        configureAndSaveChanges()
    }
    
    func deleteItem(with id: UInt32) {
        guard var habit = habit else { return }
        habit = habit.withItemDeleted(with: id)
        configureAndSaveChanges()
    }
    
    func reload() {
        // do I need it?
    }
}

extension HabitViewController: CancelDoneButtonsDelegate {
    func cancelButtonPressed(sender: UIButton) {
        isEditMode = false
    }
    
    func doneButtonPressed(sender: UIButton) {
        if let changedHabit = habitSceneView.updatedHabit() {
            let sourceGoalID = goals.filter{$0.hasItemWithID(id: habit!.id)}.first!.id
            if changedHabit.goalID == sourceGoalID {
                goals = goals.map { $0.id == changedHabit.id ? $0.withHabitChanged(habit: changedHabit) : $0 }
            }
            else {
                var sourceGoal = goals.filter{$0.hasItemWithID(id: habit!.id)}.first!
                sourceGoal = sourceGoal.withHabitRemoved(habit: habit!)
                var destinationGoal = goals.filter{$0.id == changedHabit.goalID}.first!
                destinationGoal = destinationGoal.withHabitAdded(habit: changedHabit)
            }
            for goal in goals {
                goal.isSelected = false
            }
            Goal.saveToFile(goals: goals)
            isEditMode = false
        }
    }
}
