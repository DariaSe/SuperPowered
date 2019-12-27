//
//  HabitTableViewCell.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 16/10/2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

class HabitTableViewCell: UITableViewCell {
    
    var habit: Habit? {
        didSet {
            guard let habit = habit else { return }
            updateWith(habit: habit)
        }
    }
    
    var goal: String? {
        didSet {
            goalButton.setTitle(goal, for: .normal)
        }
    }
    
    var panGestureRecognizer = UIPanGestureRecognizer()
    
    var saveDiscardDelegate: CellSaveDiscardDelegate?
    
    var quickCheckInReceiver: QuickCheckInReceiver?
    
    var goalButtonDelegate: GoalButtonDelegate?
    
    @IBOutlet weak var containerView: UIView!
  
    @IBOutlet weak var progressBar: DiscreteProgressBar!
    
    @IBOutlet weak var coloredLine: UIView!
    
    @IBOutlet weak var triggerTextViewContainer: TextViewContainer!
    @IBOutlet weak var badHabitTextViewContainer: TextViewContainer!
    @IBOutlet weak var goodHabitTextViewContainer: TextViewContainer!
    @IBOutlet weak var habitsVerticalSpacingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var goodHabitContainerToSuperviewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var moreButton: UIButton!
    @IBAction func moreButtonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, animations: {
            sender.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) { (_) in
            sender.transform = CGAffineTransform.identity
            UIView.animate(withDuration: 0.3) {
                self.cellActionsView.appear()
            }
        }
    }
    
    @IBOutlet weak var cellActionsView: CellActionsView!
    
    @IBOutlet weak var horizontalLine: UIView!
    @IBOutlet weak var badIndicatorView: GoodBadIndicatorView!
    @IBOutlet weak var goodIndicatorView: GoodBadIndicatorView!
    
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progressLabelContainer: UIView!
    
    
    @IBOutlet weak var goalButton: UIButton!
    @IBAction func goalButtonPressed(_ sender: UIButton) {
        goalButtonDelegate?.showGoals(sender: sender)
    }
    
    @IBOutlet weak var cancelDoneButtons: CancelDoneButtonsView!
    @IBOutlet weak var cancelDoneButtonsHeight: NSLayoutConstraint!
    
    @IBOutlet weak var quickCheckInView: QuickCheckInView!
    
    @IBOutlet weak var shadowingView: UIView!
    
    var showFullWidthButton: Bool = false
    var commitOnDragRelease: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        quickCheckInView.delegate = self
        setupUI()
        containerView.isUserInteractionEnabled = true
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragged(sender:)))
        panGestureRecognizer.delegate = self
        containerView.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc func dragged(sender: UIPanGestureRecognizer) {
        if sender.state == .changed {
            let translation = sender.translation(in: self.contentView)
            containerView.center = CGPoint(x: containerView.center.x + translation.x, y: containerView.center.y)
            let positionAdjustment = abs(self.center.x - containerView.center.x)
            quickCheckInView.adjustButtonWidth(translationX: positionAdjustment)
            sender.setTranslation(CGPoint.zero, in: self.contentView)
            commitOnDragRelease = positionAdjustment > 140
            showFullWidthButton = positionAdjustment > 50
            if commitOnDragRelease {
                quickCheckInView.prepareToCommit(isGood: self.containerView.center.x < self.center.x)
            }
            else {
                quickCheckInView.restore()
            }
        }
        if sender.state == .ended {
            if showFullWidthButton && !commitOnDragRelease {
                quickCheckInView.showFullButton()
                UIView.animate(withDuration: 0.3, delay: 0.1, options: [.curveEaseOut], animations: {
                    self.quickCheckInView.layoutIfNeeded()
                    self.containerView.frame = self.containerView.center.x < self.center.x ? CGRect(x: -90, y: 0, width: self.frame.width, height: self.frame.height) : CGRect(x: 90, y: 0, width: self.frame.width, height: self.frame.height)
                }, completion: nil)
            }
            if !commitOnDragRelease && !showFullWidthButton {
                // return to initial position
                quickCheckInView.adjustButtonWidth(translationX: 0)
                quickCheckInView.restore()
                restoreFrame()
            }
            if commitOnDragRelease {
                // if isGood
                if self.containerView.center.x < self.center.x {
                    
                    UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn], animations: {
                        self.containerView.frame = CGRect(x: -self.frame.width, y: 0, width: self.frame.width, height: self.frame.height)
                    }) { (_) in
                        self.quickCheckInView.commit()
                        self.quickCheckInReceiver?.addGoodCheckIn(cell: self)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            self.quickCheckInReceiver?.reload(cell: self)
                        }
                    }
                }
                else {
                    UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn], animations: {
                        self.containerView.frame = CGRect(x: self.frame.width, y: 0, width: self.frame.width, height: self.frame.height)
                    }, completion: nil)
                    quickCheckInView.commit()
                    quickCheckInReceiver?.addBadCheckIn(cell: self)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self.quickCheckInReceiver?.reload(cell: self)
                    }
                }
            }
        }
    }
    
    func restoreFrame() {
        UIView.animate(withDuration: 0.3, delay: 0.1, options: [.curveEaseOut], animations: {
            self.quickCheckInView.layoutIfNeeded()
            self.containerView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        }, completion: nil)
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if cellActionsView.alpha == 1.0 {
            return false
        }
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translation(in: superview!)
            if abs(translation.x) > abs(translation.y) {
                return true
            }
            return false
        }
        return false
    }
    
    func setupUI() {
        backgroundColor = UIColor.backgroundColor
        containerView.backgroundColor = UIColor.backgroundColor
        
        coloredLine.dropSideShadow()
        
        triggerTextViewContainer.type = .trigger
        badHabitTextViewContainer.type = .badHabit
        goodHabitTextViewContainer.type = .goodHabit
        
        badIndicatorView.isGood = false
        badIndicatorView.backgroundColor = .clear
        goodIndicatorView.isGood = true
        goodIndicatorView.backgroundColor = .clear
        
        progressLabel.font = UIFont(name: montserratSemiBold, size: 14)
        progressLabel.textColor = .white
        progressLabelContainer.layer.cornerRadius = 4
        
        let image = #imageLiteral(resourceName: "More Button")
        let tintedImage = image.withRenderingMode(.alwaysTemplate)
        moreButton.setImage(tintedImage, for: .normal)
        moreButton.tintColor = UIColor.textColor
        moreButton.showsTouchWhenHighlighted = true
        
        horizontalLine.backgroundColor = UIColor.linesColor
        horizontalLine.dropShadow(shadowRadius: 2, opacity: 0.25, cornerRadius: 0)
        
        goalButton.titleLabel?.font = UIFont(name: montserratSemiBold, size: 14)
        goalButton.tintColor = UIColor.goalTextColor
        goalButton.titleLabel?.lineBreakMode = .byTruncatingTail
        goalButton.layer.cornerRadius = 7
        
        cancelDoneButtons.delegate = self
        cancelDoneButtons.forGoal = false
        
        quickCheckInView.setupUI()
        
        shadowingView.isUserInteractionEnabled = false
        shadowingView.backgroundColor = UIColor.backgroundColor
        shadowingView.alpha = 0.5
    }
    
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func updateWith(habit: Habit) {
        let progress = habit.progress
        progressBar.progress = progress
        progressLabel.text = String(Int(progress))
        progressLabelContainer.backgroundColor = progress < 0 ? UIColor.AppColors.red : UIColor.AppColors.green
        panGestureRecognizer.isEnabled = habit.progress != 40 && !habit.isEditMode
        progressBar.isHidden = habit.isEditMode
        horizontalLine.isHidden = habit.isEditMode
        progressLabelContainer.isHidden = habit.isEditMode
        quickCheckInView.isHidden = habit.isEditMode
        moreButton.isHidden = habit.isEditMode
        
        goalButton.isHidden = !habit.isEditMode
        goalButton.backgroundColor = UIColor.goalColor(index: habit.color)
        
        triggerTextViewContainer.text = habit.trigger
        triggerTextViewContainer.isEditMode = habit.isEditMode
        
        badHabitTextViewContainer.text = habit.badHabit
        badHabitTextViewContainer.isEditMode = habit.isEditMode
        
        goodHabitTextViewContainer.text = habit.goodHabit
        goodHabitTextViewContainer.isEditMode = habit.isEditMode
        
        habitsVerticalSpacingConstraint.constant = habit.isEditMode ? 5 : -5
        goodHabitContainerToSuperviewBottomConstraint.constant = habit.isEditMode ? 90 : 5
        
        cancelDoneButtonsHeight.constant = habit.isEditMode ? 40 : 0
        cancelDoneButtons.isHidden = habit.isEditMode ? false : true
        
        coloredLine.backgroundColor = UIColor.goalColor(index: habit.color)
        
        cellActionsView.alpha = 0.0
        cellActionsView.color = UIColor.backgroundColor
        cellActionsView.setupUI()
        
        quickCheckInView.progress = habit.progress
        
        setupUI()
        shadowingView.isHidden = habit.progress != 40 || habit.isEditMode
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        quickCheckInView.isHidden = highlighted ? true : false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectedBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        selectedBackgroundView?.backgroundColor = UIColor.backgroundCompanionColor
        let colorLine = UIView(frame: CGRect(x: 0, y: 0, width: 3, height: self.frame.height))
        colorLine.backgroundColor = UIColor.goalColor(index: habit?.color ?? 0)
        selectedBackgroundView?.addSubview(colorLine)
    }
}

extension HabitTableViewCell: CancelDoneButtonsDelegate {
    func cancelButtonPressed(sender: UIButton) {
        saveDiscardDelegate?.discardChanges(cell: self)
    }
    
    func doneButtonPressed(sender: UIButton) {
        if triggerTextViewContainer.isValid && badHabitTextViewContainer.isValid && goodHabitTextViewContainer.isValid {
            saveDiscardDelegate?.saveChanges(cell: self)
        }
        else {
            NotificationCenter.default.post(name: Notification.Name(doneButtonNKey), object: nil)
        }
    }
}
extension HabitTableViewCell: QuickCheckInViewDelegate {
    func cancelCheckIn(sender: UIButton) {
        quickCheckInReceiver?.cancelLastCheckIn(cell: self)
        quickCheckInReceiver?.reload(cell: self)
    }
    
    func badHabitButtonPressed(sender: UIButton) {
        quickCheckInReceiver?.addBadCheckIn(cell: self)
        quickCheckInReceiver?.reload(cell: self)
        
    }
    
    func goodHabitButtonPressed(sender: UIButton) {
        quickCheckInReceiver?.addGoodCheckIn(cell: self)
        quickCheckInReceiver?.reload(cell: self)
    }
}

protocol QuickCheckInReceiver {
    func addBadCheckIn(cell: UITableViewCell)
    func addGoodCheckIn(cell: UITableViewCell)
    func cancelLastCheckIn(cell: UITableViewCell)
    func reload(cell: UITableViewCell)
}

protocol GoalButtonDelegate {
    func showGoals(sender: UIButton)
}
