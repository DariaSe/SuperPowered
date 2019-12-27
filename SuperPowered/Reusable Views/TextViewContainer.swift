//
//  TextViewContainer.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 16/10/2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

enum TextViewType {
    case title
    case description
    case trigger
    case badHabit
    case goodHabit
    case note
}

class TextViewContainer: UIView {
    
    var textView = UITextView()
    // to assign
    var text: String? {
        didSet {
            textView.text = self.text
            configureTextAppearance()
        }
    }
    
    var type: TextViewType? {
        didSet {
            configureTextAppearance()
        }
    }
    
    var isEditMode: Bool? {
        didSet {
            configureLayerAppearance()
        }
    }
    //
    var textViewBackgroundColor: UIColor?
    var textColor: UIColor?
    
    var placeholder: String = ""
    var placeholderTextColor: UIColor?
    
    var textChanged: ((String) -> Void)?
    
    var isValid: Bool {
        return textView.isValid(placeholder: placeholder)
    }
    
    func configureTextAppearance() {
        guard let type = type else { return }
        switch type {
        case .title:
            textViewBackgroundColor = UIColor.white.withAlphaComponent(0.2)
            textView.font = UIFont.goalTitleFont
            textColor = UIColor.goalTextColor.withAlphaComponent(0.8)
            placeholder = Goal.titlePlaceholder
            placeholderTextColor = UIColor.goalPlaceholderTextColor
        case .description:
            textViewBackgroundColor = UIColor.white.withAlphaComponent(0.2)
            textView.font = UIFont.goalDescriptionFont
            textColor = UIColor.goalTextColor.withAlphaComponent(0.8)
            placeholder = Goal.descriptionPlaceholder
            placeholderTextColor = UIColor.goalPlaceholderTextColor
        case .trigger:
            textViewBackgroundColor = UIColor.AppColors.backgroundCompanionColor
            textView.font = UIFont.triggerFont
            textColor = UIColor.textColor
            placeholder = Habit.triggerPlaceholder
            placeholderTextColor = UIColor.placeholderTextColor
            textView.textAlignment = .center
        case .badHabit:
            textViewBackgroundColor = UIColor.AppColors.backgroundCompanionColor
            textView.font = UIFont.habitFont
            textColor = UIColor.AppColors.red
            placeholder = Habit.badHabitPlaceholder
            placeholderTextColor = UIColor.AppColors.textRed
        case .goodHabit:
            textViewBackgroundColor = UIColor.AppColors.backgroundCompanionColor
            textView.font = UIFont.habitFont
            textColor = UIColor.textColor
            placeholder = Habit.goodHabitPlaceholder
            placeholderTextColor = UIColor.placeholderTextColor
        case .note:
            textViewBackgroundColor = UIColor.AppColors.backgroundCompanionColor
            textView.font = UIFont.noteFont
            textColor = UIColor.textColor
            placeholder = Note.placeholder
            placeholderTextColor = UIColor.placeholderTextColor
        }
        if textView.text == "" {
            textView.text = placeholder
        }
        textView.textColor = textView.text == placeholder ?
            placeholderTextColor : textColor
    }
    
    func configureLayerAppearance() {
        guard let isEditMode = isEditMode else { return }
        backgroundColor = .clear
        textView.layer.borderWidth = 0
        textView.layer.cornerRadius = 10
        textView.backgroundColor = isEditMode ?
            textViewBackgroundColor : .clear
        
        textView.isEditable = isEditMode ? true : false
        textView.isUserInteractionEnabled = isEditMode ? true : false
    }
    
    func commonInit() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textView)
        textView.pinToEdges(to: self)
        textView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        textView.delegate = self
        textView.isScrollEnabled = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(showInvalidTextView), name: Notification.Name(doneButtonNKey), object: nil)
    }
    
    @objc func showInvalidTextView() {
        if !isValid {
            textView.layer.borderColor = UIColor.AppColors.red.cgColor
            textView.layer.borderWidth = 2
            textView.shake()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
}

extension TextViewContainer: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let type = type else { return false }
        switch type {
        case .note:
            return textView.text.count + (text.count - range.length) <= 400
        case .description:
            return textView.text.count + (text.count - range.length) <= 120
        default:
            return textView.text.count + (text.count - range.length) <= 60
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textView.layer.borderWidth = 0
        textChanged?(textView.text)
        if textView.text.last == "\n" {
            textView.text.removeLast()
            self.endEditing(true)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.clear(placeholder: placeholder)
        textView.textColor = textColor
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.show(placeholder: placeholder, placeholderColor: placeholderTextColor!)
    }
}
