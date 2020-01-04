//
//  Habit.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 02/10/2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit
import CloudKit

class Habit: MainItem, Codable, Comparable, IDValidator {
    
    // MARK: - Properties
    
    var itemType: MainItemType {
        return .habit(self)
    }
    var id: UInt32 = arc4random()
    var goalID: UInt32
    var goalTitle: String
    
    var trigger: String {
        didSet {
            trigger.removeCarriageReturns()
        }
    }
    var badHabit: String {
        didSet {
            badHabit.removeCarriageReturns()
        }
    }
    var goodHabit: String {
        didSet {
            goodHabit.removeCarriageReturns()
        }
    }
    
    var creationDate: Date = Date()
    var isEditMode: Bool = true {
        didSet {
            if self.isEditMode {
                buffer()
            }
            else {
                self.bufferHabit = nil
            }
        }
    }
    var isFinished: Bool {
        return progress == 40
    }
    var checkIns: [CheckIn] = []
    var notes: [Note] = []
    var color: Int
    
    static let triggerPlaceholder = "Triggering situation"
    static let badHabitPlaceholder = "Your undesirable habit"
    static let goodHabitPlaceholder = "The desired action"
    
    var journalInterfaceArray: [FeedItem] {
        let checkInsFeed = checkIns.map{$0.habitType == .bad ?
            FeedItem(triggerText: $0.triggerText, text: $0.text, date: $0.date, type: .badCheckIn, id: $0.id, color: nil) :
            FeedItem(triggerText: $0.triggerText, text: $0.text, date: $0.date, type: .goodCheckIn, id: $0.id, color: nil)}
        let notesFeed = notes.map{FeedItem(triggerText: $0.triggerText, text: $0.text, date: $0.date, type: .note, id: $0.id, color: self.color)}
        var sortedArray = (checkInsFeed + notesFeed).sorted(by: >)
        if sortedArray.first?.text != "" {
            sortedArray.insert(FeedItem(triggerText: self.trigger, text: "", date: Date(), type: .note, id: arc4random(), color: self.color), at: 0)
            sortedArray[0].validateID()
            sortedArray[0].isEditMode = true
        }
        return sortedArray
    }
    
    var historyInterfaceArray: [FeedItem] {
        let checkInsFeed = checkIns.map{$0.habitType == .bad ?
            FeedItem(triggerText: $0.triggerText, text: $0.text, date: $0.date, type: .badCheckIn, id: $0.id, color: nil) :
            FeedItem(triggerText: $0.triggerText, text: $0.text, date: $0.date, type: .goodCheckIn, id: $0.id, color: nil)}
        let notesFeed = notes.map{FeedItem(triggerText: $0.triggerText, text: $0.text, date: $0.date, type: .note, id: $0.id, color: self.color)}
        let sortedArray = (checkInsFeed + notesFeed).sorted(by: >)
        
        return sortedArray
    }
    // MARK: - Series
    
    var currentSerie: Int {
        var sum = 0
        for checkIn in checkIns {
            if checkIn.habitType == .good {
                sum += 1
            }
            else { break }
        }
        return sum
    }
    var maximalSerie: Int {
        var seriesArray: [Int] = []
        var serie = 0
        for checkIn in checkIns {
            if checkIn.habitType == .good {
                serie += 1
                seriesArray.append(serie)
            }
            else {
                serie = 0
            }
        }
        return seriesArray.sorted().last ?? 0
    }
    
    // MARK: - Statistics
    
    var progress: Int {
        return checkIns.map{$0.habitType == .good ? 1 : -2}.reduce(0){$0 + $1}
    }
    
    func progressOn(date: Date) -> Int {
        return checkIns
            .filter{$0.date.dayStart() == date.dayStart()}
            .map{$0.habitType == .good ? 1 : -2}
            .reduce(0){$0 + $1}
    }
    func progressAtHour(date: Date, hour: Int) -> Int {
        return checkIns
            .filter{$0.date.dayStart() == date.dayStart()}
            .filter{$0.date.hour == hour}
            .map{$0.habitType == .good ? 1 : -2}
            .reduce(0){$0 + $1}
    }
    
    func goodCheckInsOn(date: Date) -> Int {
        return checkIns.filter{$0.date.dayStart() == date.dayStart() && $0.habitType == .good}.count
    }
    
    func goodCheckInsAtHour(date: Date, hour: Int) -> Int {
        return checkIns
            .filter{$0.date.dayStart() == date.dayStart() && $0.habitType == .good}
            .filter{$0.date.hour == hour}
            .count
    }
    
    func badCheckInsOn(date: Date) -> Int {
        return checkIns.filter{$0.date.dayStart() == date.dayStart() && $0.habitType == .bad}.count
    }
    
    func badCheckInsAtHour(date: Date, hour: Int) -> Int {
        return checkIns
            .filter{$0.date.dayStart() == date.dayStart() && $0.habitType == .bad}
            .filter{$0.date.hour == hour}
            .count
    }
    
    var daysSinceTriggerWasSet: Int {
        let startDateStart = Calendar.current.dateInterval(of: .day, for: self.creationDate)!.start
        let numberOfDays = Calendar.current.dateComponents([.day], from: startDateStart, to: Date()).day! + 1
        return numberOfDays
    }
    
    var daysOfWorkingOnTheTrigger: StatisticsItem {
        let number = daysSinceTriggerWasSet
        let day = "day".pluralizedOrNotForNumber(number: number)
        let text = "\(day) since the start"
        return StatisticsItem(number: number, text: text)
    }
    
    var totalProgress: StatisticsItem {
        let number = progress
        let step = "step".pluralizedOrNotForNumber(number: number)
        let text = "\(step) forward on the path of self-improvement"
        return StatisticsItem(number: number, text: text)
    }
    
    var goodCheckIns: StatisticsItem {
        let number = checkIns.filter{$0.habitType == .good}.count
        let decision = "decision".pluralizedOrNotForNumber(number: number)
        let text = "right \(decision) made"
        return StatisticsItem(number: number, text: text)
    }
    
    var badCheckIns: StatisticsItem {
        let number = checkIns.filter{$0.habitType == .bad}.count
        let time = "time".pluralizedOrNotForNumber(number: number)
        let text = "\(time) the ingrained habits took over"
        return StatisticsItem(number: number, text: text)
    }
    
    var currentSerieItem: StatisticsItem {
        let number = currentSerie
        let text = "current serie"
        return StatisticsItem(number: number, text: text)
    }
    
    var maximalSerieItem: StatisticsItem {
        let number = maximalSerie
        let text = "maximal serie"
        return StatisticsItem(number: number, text: text)
    }
    
    var notesWritten: StatisticsItem {
        let number = notes.count
        let thought = "thought".pluralizedOrNotForNumber(number: number)
        let andOr = number == 1 ? "or" : "and"
        let insight = "insight".pluralizedOrNotForNumber(number: number)
        let text = "\(thought) \(andOr) \(insight) written down"
        return StatisticsItem(number: number, text: text)
    }
    
    var statisticsItems: [StatisticsItem] {
        return [daysOfWorkingOnTheTrigger, currentSerieItem, maximalSerieItem, goodCheckIns, badCheckIns, notesWritten]
    }
    // MARK: - Init
    init(trigger: String, badHabit: String, goodHabit: String, color: Int, goalID: UInt32, goalTitle: String) {
        self.trigger = trigger
        self.badHabit = badHabit
        self.goodHabit = goodHabit
        self.color = color
        self.goalID = goalID
        self.goalTitle = goalTitle
    }
    
    // MARK: - Methods
    
    static func at(indexPath: IndexPath, in array: [Goal])  -> Habit {
        return array[indexPath.section].habits[indexPath.row - 1]
    }
    
    func duplicated() -> Habit {
        let habit = Habit(trigger: self.trigger, badHabit: self.badHabit, goodHabit: self.goodHabit, color: self.color, goalID: self.goalID, goalTitle: self.goalTitle)
        habit.creationDate = self.creationDate
        habit.id = self.id
        habit.isEditMode = self.isEditMode
        habit.checkIns = self.checkIns
        habit.notes = self.notes
        return habit
    }
    
    func withColorChanged(index: Int) -> Habit {
        self.color = index
        return self
    }
    
    // MARK: - CheckIns nad notes Management
    
    func withCheckInAdded(habitType: HabitType) -> Habit {
        let text = habitType == .good ? self.goodHabit : self.badHabit
        checkIns.insert(CheckIn(habitID: self.id, text: text, triggerText: self.trigger, habitType: habitType), at: 0)
        checkIns[0].validateID()
        return self
    }
    
    func withLastCheckInCancelled() -> Habit {
        if !checkIns.isEmpty {
            checkIns.removeFirst()
        }
        return self
    }
    
    func hasItemWithID(id: UInt32) -> Bool {
        return !checkIns.filter { $0.id == id }.isEmpty
            || !notes.filter { $0.id == id }.isEmpty
            || self.id == id
    }
    
    func withItemChanged(replaceWith text: String, itemWith id: UInt32) -> Habit {
        notes = notes.map { $0.id == id ? $0.withTextChanged(text: text) : $0 }
        checkIns = checkIns.map {$0.id == id ? $0.withTextChanged(text: text) : $0 }
        return self
    }
    
    func withItemDeleted(with id: UInt32) -> Habit {
        notes = notes.filter { $0.id != id }
        checkIns = checkIns.filter { $0.id != id }
        return self
    }
    
    // MARK: - Buffering
    
    var bufferHabit: BufferHabit?
    
    struct BufferHabit: Codable {
        var trigger: String
        var badHabit: String
        var goodHabit: String
        var goalId: UInt32
        var goalTitle: String
        var color: Int
    }
    
    func buffer() {
        self.bufferHabit = BufferHabit(trigger: self.trigger, badHabit: self.badHabit, goodHabit: self.goodHabit, goalId: self.goalID, goalTitle: self.goalTitle, color: self.color)
    }
    
    func restoreFromBuffer() {
        if let bufferHabit = self.bufferHabit {
            self.trigger = bufferHabit.trigger
            self.badHabit = bufferHabit.badHabit
            self.goodHabit = bufferHabit.goodHabit
            self.color = bufferHabit.color
            self.goalID = bufferHabit.goalId
            self.goalTitle = bufferHabit.goalTitle
        }
        self.isEditMode = false
    }
    
    // MARK: - Alerts
    
    func alertFinished(handler: ((UIAlertAction) -> ())?) -> UIAlertController? {
        if self.progress == 40 {
            let alert = UIAlertController(title: "Congratulations!", message: "You've beaten this bad habit!", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: handler)
            alert.addAction(action)
            return alert
        }
        else {
            return nil
        }
    }
    
    func alertFailed() -> UIAlertController? {
        if self.progress <= -6 {
            let alert = UIAlertController(title: "Hmmmm...", message: "It seems that things didn't go as expected. Try to replace this bad habit with another good one and start over!", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default) { (action) in
                self.isEditMode = true
                self.checkIns.removeAll()
            }
            alert.addAction(action)
            return alert
        }
        else {
            return nil
        }
    }
    // MARK: - Comparable
    
    static func < (lhs: Habit, rhs: Habit) -> Bool {
        return lhs.creationDate < rhs.creationDate
    }
    
    static func == (lhs: Habit, rhs: Habit) -> Bool {
        lhs.creationDate == rhs.creationDate
    }
    
    // MARK: - iCloud
    
    func preparedForCloud(record: CKRecord?) -> CKRecord {
        var recordToSave: CKRecord
        if let record = record {
            recordToSave = record
        }
        else {
            recordToSave = CKRecord(recordType: "Habit")
        }
        recordToSave[.trigger] = trigger
        recordToSave[.badHabit] = badHabit
        recordToSave[.goodHabit] = goodHabit
        recordToSave[.date] = creationDate
        recordToSave[.id] = id
        recordToSave[.color] = color
        recordToSave[.goalID] = goalID
        recordToSave[.goalTitle] = goalTitle
        
        return recordToSave
    }
}

enum HabitKey: String {
    case trigger, badHabit, goodHabit, goalID, goalTitle
}

extension CKRecord {
    subscript(key: HabitKey) -> Any? {
        get {
            return self[key.rawValue]
        }
        set {
            self[key.rawValue] = newValue as? CKRecordValue
        }
    }
}
