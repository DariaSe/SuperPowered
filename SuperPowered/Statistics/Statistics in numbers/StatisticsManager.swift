//
//  StatisticsManager.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 18.11.2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

class StatisticsManager {
    var goals: [Goal] = []
    
    // MARK: - Level
    
    var levels: [Int: Int] {
        return [1 : 0, 2 : 10, 3 : 20, 4 : 40, 5 : 60, 6 : 90, 7 : 120, 8 : 160, 9 : 200, 10 : 250, 11 : 310, 12 : 370, 13 : 430, 14 : 500, 15 : 570, 16 : 640, 17 : 710, 18 : 860, 19 : 930, 20 : 1000, 21 : 1100, 22 : 1200, 23 : 1300, 24 : 1400, 25 : 1500, 26 : 1600, 27 : 1700, 28 : 1800, 29 : 1900, 30 : 2000, 31 : 2100, 32 : 2200, 33 : 2400, 34 : 2600, 35 : 2900, 36 : 3200, 37 : 3600, 38 : 4000, 39 : 4500, 40 : 5000]
    }
    
    var totalProgress: Int {
        return goals.map{$0.totalProgress.number}.reduce(0){$0 + $1}
    }
    
    var level: Int {
        let filteredLevels = levels.filter{$0.value > totalProgress}
        let level = Array(filteredLevels).sorted(by: {$0.value < $1.value}).first!
        return level.key
    }
    var currentLevelProgress: Int {
        return levels[level - 1] ?? 0
    }
    
    var nextLevelProgress: Int {
        return levels[level] ?? 0
    }
    
    // MARK: - Statistics in numbers
    
    var numberOfGoals: StatisticsItem {
        let number = goals.count
        let goal = "goal".pluralizedOrNotForNumber(number: number)
        let text = "\(goal) set"
        return StatisticsItem(number: number, text: text)
    }
    
    var triggers: StatisticsItem {
        let number = goals.map{$0.habits.count}.reduce(0){$0 + $1}
        let trigger = "trigger".pluralizedOrNotForNumber(number: number)
        let text = "\(trigger) detected"
        return StatisticsItem(number: number, text: text)
    }
    
    var finished: StatisticsItem {
        let number = goals.map{$0.numberOfFinished.number}.reduce(0){$0 + $1}
        let habit = "habit".pluralizedOrNotForNumber(number: number)
        let text = "bad \(habit) beaten"
        return StatisticsItem(number: number, text: text)
    }
    
    var goodCheckIns: StatisticsItem {
        let number = goals.map{$0.goodCheckIns.number}.reduce(0){$0 + $1}
        let decision = "decision".pluralizedOrNotForNumber(number: number)
        let text = "right \(decision) made"
        return StatisticsItem(number: number, text: text)
    }
    
    var badCheckIns: StatisticsItem {
        let number = goals.map{$0.badCheckIns.number}.reduce(0){$0 + $1}
        let time = "time".pluralizedOrNotForNumber(number: number)
        let text = "\(time) the ingrained habits took over"
        return StatisticsItem(number: number, text: text)
    }
    
    var notesWritten: StatisticsItem {
        let number = goals.map{$0.notesWritten.number}.reduce(0){$0 + $1}
        let thought = "thought".pluralizedOrNotForNumber(number: number)
        let andOr = number == 1 ? "or" : "and"
        let insight = "insight".pluralizedOrNotForNumber(number: number)
        let text = "\(thought) \(andOr) \(insight) written down"
        return StatisticsItem(number: number, text: text)
    }
    
    var statisticsItems: [StatisticsItem] {
        return [numberOfGoals, triggers, finished, goodCheckIns, badCheckIns, notesWritten]
    }
    
   
    
    // MARK: - Graphs and charts
    
//    func progressOn(date: Date) -> Int {
//        return goals.map{$0.progressOn(date: date)}.reduce(0){$0 + $1}
//    }
    
//    func averageProgressOn(date: Date) -> Int {
//        if goals.count != 0 { return progressOn(date: date) / goals.count }
//        else { return 0 }
//    }
    
//    func goodCheckInsOn(date: Date) -> Int {
//        return goals.map{$0.goodCheckInsOn(date: date)}.reduce(0){$0 + $1}
//    }
//
//    func badCheckInsOn(date: Date) -> Int {
//        return goals.map{$0.goodCheckInsOn(date: date)}.reduce(0){$0 + $1}
//    }
    
}
