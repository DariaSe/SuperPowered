//
//  AchievementsStackView.swift
//  Triggio
//
//  Created by Дарья Селезнёва on 16/09/2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

class AchievementsStackView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    var a3milestoneView = AchievementView()
    var a7milestoneView = AchievementView()
    var a14milestoneView = AchievementView()
    var a21milestoneView = AchievementView()
    var a40milestoneView = AchievementView()
    
    var topLineView = UIView()
    var bottomLineView = UIView()
    
    var habit: Habit? {
        didSet {
            guard let habit = habit else { return }
            commonInit()
            configureViews()
            setNeedsDisplay()
            switch habit.currentSerie {
            case 3:
                animateOnMatch(view: a3milestoneView)
            case 7:
                animateOnMatch(view: a7milestoneView)
            case 14:
                animateOnMatch(view: a14milestoneView)
            case 21:
                animateOnMatch(view: a21milestoneView)
            case 40:
               animateOnMatch(view: a40milestoneView)
            default:
                break
            }
        }
    }
    
    func commonInit() {
        self.backgroundColor = .clear
        a3milestoneView.removeFromSuperview()
        a3milestoneView = prepareAchievementView(number: 3)
        a7milestoneView.removeFromSuperview()
        a7milestoneView = prepareAchievementView(number: 7)
        a14milestoneView.removeFromSuperview()
        a14milestoneView = prepareAchievementView(number: 14)
        a21milestoneView.removeFromSuperview()
        a21milestoneView = prepareAchievementView(number: 21)
        a40milestoneView.removeFromSuperview()
        a40milestoneView = prepareAchievementView(number: 40)
        
        topLineView.removeFromSuperview()
        topLineView = UIView(frame: CGRect(x: edgePadding,
                                               y: 0,
                                               width: screenWidth - edgePadding * 2,
                                               height: 1))
        self.addSubview(topLineView)
        topLineView.backgroundColor = UIColor.linesColor
        topLineView.dropShadow(shadowRadius: 3, opacity: 0.25, cornerRadius: 0)
        
        bottomLineView.removeFromSuperview()
        bottomLineView = UIView(frame: CGRect(x: edgePadding,
                                                  y: self.frame.height - 3,
                                                  width: screenWidth - edgePadding * 2,
                                                  height: 1))
        self.addSubview(bottomLineView)
        bottomLineView.backgroundColor = UIColor.linesColor
        bottomLineView.dropShadow(shadowRadius: 3, opacity: 0.25, cornerRadius: 0)
    }
    
    func prepareAchievementView(number: Int) -> AchievementView {
        let viewWidthHeight = screenWidth / 8
        let interItemSpacing = (screenWidth - viewWidthHeight * 5 - edgePadding * 2) / 4
        let numbers = [3, 7, 14, 21, 40]
        var xPositionDic: [Int: CGFloat] = [:]
        for multiplier in 0...4 {
            let xPosition = edgePadding + (viewWidthHeight + interItemSpacing) * CGFloat(multiplier)
            xPositionDic.updateValue(xPosition, forKey: numbers[multiplier])
        }
        let view = AchievementView(frame: CGRect(x: xPositionDic[number]!,
                                                 y: self.frame.height / 2 - viewWidthHeight / 2 - 3,
                                                 width: viewWidthHeight,
                                                 height: viewWidthHeight))
        
        self.addSubview(view)
        
        return view
    }
    
    func configureAchievementView(view: AchievementView, number: Int) {
        guard let habit = habit else { return }
        view.number = number
        view.actualSerie = habit.currentSerie
        view.maximalSerie = habit.maximalSerie
        view.setLabelText()
        view.drawCircle()
    }
    
    func configureViews() {
        configureAchievementView(view: a3milestoneView, number: 3)
        configureAchievementView(view: a7milestoneView, number: 7)
        configureAchievementView(view: a14milestoneView, number: 14)
        configureAchievementView(view: a21milestoneView, number: 21)
        configureAchievementView(view: a40milestoneView, number: 40)
    }
    
    func animateOnMatch(view: AchievementView) {
        UIView.animate(withDuration: 0.2, animations: {
            view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }, completion: nil)
        UIView.animate(withDuration: 0.1, delay: 0.4, animations: {
            view.transform = CGAffineTransform.identity
        }, completion: nil)
    }
}
