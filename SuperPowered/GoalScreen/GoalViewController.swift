//
//  GoalViewController.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 16.11.2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

class GoalViewController: GoalsBaseViewController {
    
    var goalID: UInt32?
    var bufferedColorIndex: Int?
    
    var selected: Bool = false
    
    var isGoalEditing: Bool = false {
        didSet {
            setupGoalViewColor()
            setupGoalView()
            UIView.animate(withDuration: 0.3) {
                 self.view.layoutIfNeeded()
            }
        }
    }
    
    @IBOutlet weak var goalViewContainer: UIView!
    
    @IBOutlet weak var titleTextViewContainer: TextViewContainer!
    
    @IBOutlet weak var textViewsSpacingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var descriptionTextViewContainer: TextViewContainer!
    
    @IBOutlet weak var descriptionToButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var descriptionToSuperviewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tabSwitcher: TabsSwitcherView!
    
    @IBOutlet weak var statisticsContainer: StatisticContainer!
 
    @IBOutlet weak var historyTableViewContainer: HistoryTableViewContainer!
    
    @IBOutlet weak var shieldView: UIView!
    
    @IBOutlet weak var colorPickerButton: UIButton!
    @IBAction func colorPckerButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let colorPickerVC = storyboard.instantiateViewController(withIdentifier: "colorPickerVC") as! ColorPickerViewController
        colorPickerVC.delegate = self
        colorPickerVC.modalPresentationStyle = .overCurrentContext
        colorPickerVC.view.backgroundColor = UIColor.backgroundCompanionColor.withAlphaComponent(0.6)
        present(colorPickerVC, animated: true)
    }
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBAction func cancelButtonPressed(_ sender: Any) {
        goal!.color = bufferedColorIndex!
        isGoalEditing = false
        tableView.reloadData()
    }
    
    @IBOutlet weak var doneButton: UIButton!
    @IBAction func doneButtonPressed(_ sender: Any) {
        goal?.title = titleTextViewContainer.textView.text
        goal?.description = descriptionTextViewContainer.textView.text
        isGoalEditing = false
        Goal.saveToFile(goals: goals)
        bufferedColorIndex = nil
    }
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        bufferedColorIndex = goal?.color
        isGoalEditing = true
    }
    
    
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    @IBAction func deleteButtonPressed(_ sender: UIBarButtonItem) {
        guard let goal = goal else { return }
        let alert = UIAlertController(title: "Warning!", message: "Do you really want to delete this goal?", preferredStyle: .alert)
        let yes = UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in
            self.goals = self.goals.filter { $0.id != goal.id }
            Goal.saveToFile(goals: self.goals)
            self.navigationController?.popToRootViewController(animated: true)
        })
        let no = UIAlertAction(title: "No", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        })
        alert.addAction(no)
        alert.addAction(yes)
        
        self.present(alert, animated: true)
    }
    
    
    
    override var interfaceSource: [[MainItem]] { return [(goal?.goalScreenInterfaceArray ?? [])] }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let goalID = goalID else { return }
        goal = goals.filter{$0.id == goalID}.first
        setupGoalViewColor()
        setupGoalView()
        configureButtons()
        
        tableView.tag = 0
        statisticsContainer.tag = 1
        historyTableViewContainer.tag = 2
        
        tabSwitcher.delegate = self
        historyTableViewContainer.filterView.delegate = self
        historyTableViewContainer.delegate = self
     
        setupStatistics()
        setupHistory()
        historyTableViewContainer.tableView.backgroundColor = .clear
        historyTableViewContainer.tableView.separatorColor = .clear
        constrainTableViewTop(to: tabSwitcher, attribute: .bottom)
        tableViewTopConstraint.constant = 5
        
        navigationController?.navigationBar.tintColor = UIColor.textColor
        historyTableViewContainer.backgroundColor = UIColor.backgroundColor
        self.view.backgroundColor = UIColor.backgroundColor
        view.bringSubviewToFront(shieldView)
        shieldView.backgroundColor = UIColor.backgroundColor.withAlphaComponent(0.4)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let goalID = goalID else { return }
        goal = goals.filter{$0.id == goalID}.first
        setupStatistics()
        setupHistory()
    }
    
    override func setupGoalViewColor() {
        guard let goal = goal else { return }
        goalViewContainer.backgroundColor = UIColor.goalColor(index: goal.color)
    }
    
    func setupGoalView() {
        guard let goal = goal else { return }
        goal.isEditMode = isGoalEditing
        configureTextViews()
        textViewsSpacingConstraint.constant = isGoalEditing ? 5 : -5
        if isGoalEditing {
            descriptionToSuperviewConstraint.isActive = false
            descriptionToButtonConstraint.isActive = true
        }
        else {
            descriptionToButtonConstraint.isActive = false
            descriptionToSuperviewConstraint.isActive = true
        }
        UIView.animate(withDuration: 0.3) {
            self.colorPickerButton.alpha = self.isGoalEditing ? 1.0 : 0.0
            self.cancelButton.alpha = self.isGoalEditing ? 1.0 : 0.0
            self.doneButton.alpha = self.isGoalEditing ? 1.0 : 0.0
        }
        editButton.isEnabled = !isGoalEditing
        editButton.tintColor = isGoalEditing ?  UIColor.barBackgroundColor.withAlphaComponent(0.0) : UIColor.textColor
        deleteButton.isEnabled = isGoalEditing
        deleteButton.tintColor = isGoalEditing ? UIColor.AppColors.red : UIColor.barBackgroundColor.withAlphaComponent(0.0)
        
        shieldView.isHidden = !isGoalEditing
    }
    func configureTextViews() {
        guard let goal = goal else { return }
        titleTextViewContainer.type = .title
        titleTextViewContainer.isEditMode = goal.isEditMode
        titleTextViewContainer.text = goal.title
        
        descriptionTextViewContainer.type = .description
        descriptionTextViewContainer.isEditMode = goal.isEditMode
        descriptionTextViewContainer.text = goal.description
    }
    
    func configureButtons() {
        colorPickerButton.titleLabel?.font = UIFont(name: montserratMedium, size: 16)
        colorPickerButton.setTitleColor(UIColor.goalTextColor, for: .normal)
        
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.cornerRadius = 15
        cancelButton.layer.borderColor = UIColor.linesColor.cgColor
        cancelButton.titleLabel?.font = UIFont(name: montserratRegular, size: 16)
        cancelButton.setTitleColor(UIColor.goalTextColor, for: .normal)
        
        doneButton.layer.borderWidth = 1
        doneButton.layer.cornerRadius = 15
        doneButton.layer.borderColor = UIColor.linesColor.cgColor
        doneButton.titleLabel?.font = UIFont(name: montserratRegular, size: 16)
        doneButton.setTitleColor(UIColor.goalTextColor, for: .normal)
    }
    
    func setupStatistics() {
        guard let goal = goal else { return }
        statisticsContainer.chartManager.goal = goal
        statisticsContainer.configureAppearance()
        statisticsContainer.statisticsItems = goal.statisticsItems
        statisticsContainer.setupUI()
    }
    
    func setupFilter() {
        guard let goal = goal else { return }
        historyTableViewContainer.setupFilter(notes: goal.showNote, bad: goal.showBadHabits, good: goal.showGoodHabits)
//        filterView.showNotes = goal.showNote
//        filterView.showGoodHabits = goal.showGoodHabits
//        filterView.showBadHabits = goal.showBadHabits
//        filterView.setupUI()
    }
       
    func setupHistory() {
        guard let goal = goal else { return }
        setupFilter()
        historyTableViewContainer.feedItems = goal.selfHistoryInterfaceArray
        historyTableViewContainer.tableView.reloadData()
    }
}

extension GoalViewController: TabSwitcherDelegate {
    func tabSelected(index: Int) {
        guard let statisticsContainer = statisticsContainer, let historyTableViewContainer = historyTableViewContainer else { return }
        let views = [tableView, statisticsContainer, historyTableViewContainer]
        for view in views {
            view.isHidden = index != view.tag
        }
        setupStatistics()
        setupHistory()
        tableView.reloadData()
    }
}

extension GoalViewController: HistoryFilterViewDelegate {
    func showNotes() {
        guard let goal = goal else { return }
        goal.showNote = !goal.showNote
        Goal.saveToFile(goals: goals)
        setupHistory()
    }
    
    func showBadHabits() {
        guard let goal = goal else { return }
        goal.showBadHabits = !goal.showBadHabits
        Goal.saveToFile(goals: goals)
        setupHistory()
    }
    
    func showGoodHabits() {
        guard let goal = goal else { return }
        goal.showGoodHabits = !goal.showGoodHabits
        Goal.saveToFile(goals: goals)
        setupHistory()
    }
}
