//
//  HabitScene.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 08/10/2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

protocol HabitSceneDelegate {
    func addGoodCheckIn()
    func addBadCheckIn()
    func cancelCheckIn()
    func updateGoalButton(goalID: UInt32)
    func restart()
    func delete()
}

class HabitScene: UIView, UIGestureRecognizerDelegate {
    
    var delegate: HabitSceneDelegate?
    
    var habit: Habit?  {
        didSet {
            guard let habit = habit else { return }
            updateWithHabit(habit: habit)
        }
    }
    
    var isGoalsTableViewShown: Bool = false
    var goalsTableViewHeight: CGFloat?
  
    var textViewsAreValid: Bool { triggerTextViewContainer.isValid && badHabitTextViewContainer.isValid && goodHabitTextViewContainer.isValid }
    
    func updateWithHabit(habit: Habit) {
        
        progressBar.progress = habit.progress
        
        triggerTextViewContainer.text = habit.trigger
        badHabitTextViewContainer.text = habit.badHabit
        goodHabitTextViewContainer.text = habit.goodHabit
  
        if !habit.checkIns.isEmpty {
            batteriesView.progress = habit.progress
            batteriesView.lastCheckInType = habit.checkIns.first?.habitType
        }
        else {
            batteriesView.restart()
        }
        
        progressLabelContainer.backgroundColor =
            habit.progress < 0 ? UIColor.AppColors.red : UIColor.AppColors.green
        progressLabel.text = "\(habit.progress)"
        
        badSideTapableView.isHidden = habit.progress == 40
        goodSideTapableView.isHidden = habit.progress == 40
    }
    
    var isEditMode: Bool = false {
        didSet {
            setupUIForEditMode()
        }
    }
    
    func setupUIForEditMode() {
        progressBar.isHidden = isEditMode
        
        triggerTextViewContainer.isEditMode = isEditMode
        badHabitTextViewContainer.isEditMode = isEditMode
        goodHabitTextViewContainer.isEditMode = isEditMode
        
        habitsHorizontalLineSpacingConstraint.constant = isEditMode ? 20 : 2
        
        if isEditMode {
            batteriesAspectRatioConstraint.isActive = false
            batteriesAnotherAspectRatioConstraint.isActive = true
        }
        else {
            batteriesAnotherAspectRatioConstraint.isActive = false
            batteriesAspectRatioConstraint.isActive = true

        }
        verticalLineView.isHidden = isEditMode
        
        goalSelectorContainer.isHidden = !isEditMode
        batteriesView.isHidden = isEditMode
        progressLabelContainer.isHidden = isEditMode
        
        badSideTapableView.isUserInteractionEnabled = !isEditMode
        goodSideTapableView.isUserInteractionEnabled = !isEditMode
    }
    
    // MARK: - Outlets
    
    @IBOutlet var contentView: HabitScene!
    
    @IBOutlet weak var triggerTextViewContainer: TextViewContainer!
    @IBOutlet weak var badHabitTextViewContainer: TextViewContainer!
    @IBOutlet weak var goodHabitTextViewContainer: TextViewContainer!
    
    @IBOutlet weak var habitsHorizontalLineSpacingConstraint: NSLayoutConstraint!

    @IBOutlet weak var progressBar: DiscreteProgressBar!
    
    @IBOutlet weak var horizontalLineView: UIView!
    @IBOutlet weak var verticalLineView: UIView!
   
    @IBOutlet weak var batteriesView: BatteriesView!
    
    @IBOutlet weak var batteriesAspectRatioConstraint: NSLayoutConstraint!
    @IBOutlet weak var batteriesAnotherAspectRatioConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var badSideTapableView: UIView!
    @IBOutlet weak var goodSideTapableView: UIView!
    
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progressLabelContainer: UIView!
    
    @IBOutlet weak var goalSelectorContainer: UIView!
    @IBOutlet weak var goalButton: UIButton!
    
    @IBAction func goalButtonPressed(_ sender: UIButton) {
        isGoalsTableViewShown = !isGoalsTableViewShown
        goalsTableViewContainerHeightConstraint.constant = isGoalsTableViewShown ? goalsTableViewHeight ?? 0 : 0
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    @IBOutlet weak var goalsTableViewContainer: GoalsTableViewContainer!
    @IBOutlet weak var goalsTableViewContainerHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var cancelDoneButtonsView: CancelDoneButtonsView!
    
    @IBOutlet weak var restartButton: UIButton!
    
    @IBOutlet weak var restartTextButton: UIButton!
    @IBAction func restartButtonPressed(_ sender: UIButton) {
        delegate?.restart()
    }
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var deleteTextButton: UIButton!
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        delegate?.delete()
    }
    
    // MARK: - Goals selector
    
    func updateSelector(with goals: [Goal]) {
        guard let habit = habit else { return }
        let currentGoal = goals.filter{$0.id == habit.goalID}.first!
        for goal in goals {
            goal.isSelected = false
        }
        currentGoal.isSelected = true
        updateGoalButton(with: currentGoal)
        goalsTableViewContainer.goals = goals
        goalsTableViewContainer.selectedGoalID = habit.goalID
        goalsTableViewHeight = goals.count > 3 ? 132 : 44 * goals.count.cgFloat
        goalsTableViewContainerHeightConstraint.constant = isGoalsTableViewShown ? goalsTableViewHeight ?? 0 : 0
        
    }
    
    func updateGoalButton(with goal: Goal) {
        goalButton.titleLabel?.font = UIFont(name: montserratSemiBold, size: 14)
        goalButton.tintColor = UIColor.goalTextColor
        goalButton.titleLabel?.lineBreakMode = .byTruncatingTail
        goalButton.layer.cornerRadius = 7
        goalButton.backgroundColor = UIColor.goalColor(index: goal.color)
        goalButton.setTitle(goal.title, for: .normal)
    }
    
    // MARK: Methods
    
    func updatedHabit() -> Habit? {
        guard textViewsAreValid else {
            NotificationCenter.default.post(name: Notification.Name(doneButtonNKey), object: nil)
            return nil
        }
        habit?.trigger = triggerTextViewContainer.textView.text ?? ""
        habit?.badHabit = badHabitTextViewContainer.textView.text ?? ""
        habit?.goodHabit = goodHabitTextViewContainer.textView.text ?? ""
        habit?.goalID = goalsTableViewContainer.selectedGoalID!
        return habit
    }
    
    // MARK: - Gesture recognizers
    
    var badSideOneTapRecognizer = UITapGestureRecognizer()
    var goodSideOneTapRecognizer = UITapGestureRecognizer()
 
    func configureGestureRecognizers() {
        badSideOneTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(badSideTappedOnce(recognizer:)))
        goodSideOneTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(goodSideTappedOnce(recognizer:)))
        
        badSideOneTapRecognizer.delegate = self
        badSideTapableView.addGestureRecognizer(badSideOneTapRecognizer)
        
        goodSideOneTapRecognizer.delegate = self
        goodSideTapableView.addGestureRecognizer(goodSideOneTapRecognizer)

    }
    
    @objc func badSideTappedOnce(recognizer: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.2, animations: {
            self.badSideTapableView.backgroundColor = UIColor.AppColors.placeholderTextColor.withAlphaComponent(0.1)
        }) { (true) in
            self.badSideTapableView.backgroundColor = .clear
        }
        delegate?.addBadCheckIn()
    }
    
    @objc func goodSideTappedOnce(recognizer: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.2, animations: {
            self.goodSideTapableView.backgroundColor = UIColor.AppColors.placeholderTextColor.withAlphaComponent(0.1)
        }) { (true) in
            self.goodSideTapableView.backgroundColor = .clear
        }
        delegate?.addGoodCheckIn()
    }
    
    // MARK: - Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("HabitScene", owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.backgroundColor = .clear
        
        setupInitialConfiguration()
    }
    
    // everything that is not to be changed
    func setupInitialConfiguration() {
        configureTextViews()
        configureLines()
        configureGoalsSelector()
        setupProgressLabelAppearance()
        configureTapableViews()
        configureGestureRecognizers()
        configureRestartDeleteButtons()
        setupUIForEditMode()
    }
    
    func configureTextViews() {
        triggerTextViewContainer.type = .trigger
        badHabitTextViewContainer.type = .badHabit
        badHabitTextViewContainer.textView.textAlignment = .center
        goodHabitTextViewContainer.type = .goodHabit
        goodHabitTextViewContainer.textView.textAlignment = .center
    }
    
    func configureLines() {
        horizontalLineView.backgroundColor = UIColor.linesColor
        horizontalLineView.dropShadow(shadowRadius: 2, opacity: 0.25, cornerRadius: 0)
        verticalLineView.backgroundColor = UIColor.linesColor
    }
    
    func configureGoalsSelector() {
        goalSelectorContainer.backgroundColor = UIColor.backgroundColor
        goalsTableViewContainer.delegate = self
    }
    
    func setupProgressLabelAppearance() {
        let fontSize: CGFloat = isPhone ? 16 : 18
        progressLabel.font = UIFont(name: montserratSemiBold, size: fontSize)
        progressLabel.textColor = .white
        progressLabelContainer.layer.cornerRadius = isPhone ? 5 : 7
    }
    
    func configureTapableViews() {
           badSideTapableView.backgroundColor = .clear
           goodSideTapableView.backgroundColor = .clear
    }
    
    func configureRestartDeleteButtons() {
        restartButton.setTintedImage(imageNamed: "restartMy", tintColor: UIColor.textColor, for: .normal)
        restartTextButton.titleLabel?.font = UIFont(name: montserratMedium, size: 14)
        restartTextButton.setTitleColor(UIColor.textColor, for: .normal)
        
        deleteButton.setTintedImage(imageNamed: "deleteF", tintColor: UIColor.textColor, for: .normal)
        deleteTextButton.titleLabel?.font = UIFont(name: montserratMedium, size: 14)
        deleteTextButton.setTitleColor(UIColor.textColor, for: .normal)
    }
}

extension HabitScene: GoalsTableViewDelegate {
    func goalSelected(id: UInt32) {
        delegate?.updateGoalButton(goalID: id)
    }
}
