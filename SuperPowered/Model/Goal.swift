//
//  Goal.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 02/10/2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

class Goal: MainItem, Codable, Comparable, IDValidator {
// MARK: - Properties
    
    var itemType: MainItemType {
        return .goal(self)
    }
    var id: UInt32 = arc4random()
    var title: String {
        didSet {
            for habit in habits {
                habit.goalTitle = self.title
            }
        }
    }
    var description: String
    var creationDate: Date = Date()
    var isFinished: Bool {
        return !habits.isEmpty && (habits.filter { $0.isFinished }.count == habits.count)
    }
    var isFinishedConfirmationShown: Bool = false
    
    func withFinishedConfirmationShown() -> Goal {
        self.isFinishedConfirmationShown = true
        return self
    }
    
    var isCollapsed: Bool = false
    var isEditMode: Bool = true
    var color: Int {
        didSet {
            habits = habits.map { $0.withColorChanged(index: self.color) }
        }
    }
    
    var habits: [Habit] = []
    
    var bufferGoal: BufferGoal?
    var newHabitIndex: Int?
    
    var isSelected: Bool = false
    
    static let titlePlaceholder = "Add a goal..."
    static let descriptionPlaceholder = "Add some motivating description..."
    
    var goalScreenInterfaceArray: [MainItem] {
        return habits + [AddItem(color: self.color)]
    }
    
    // MARK: - Init
    
    init(title: String, description: String, color: Int) {
        self.title = title
        self.description = description
        self.color = color
    }

// MARK: - Filtering and sorting
    
    var mainInterfaceArray: [MainItem] {
        let showActive: Bool = defaults.bool(forKey: showActiveItemsKey)
        let showFinished: Bool = defaults.bool(forKey: showFinishedItemsKey)
        let latestFirst: Bool = defaults.bool(forKey: sortLatestFirstKey)
        var arr: [MainItem] = [self] + self.habits.filter { !$0.isFinished }.sorted(by: { latestFirst ? $0 > $1 : $0 < $1 }) + self.habits.filter { $0.isFinished }.sorted(by: { latestFirst ? $0 > $1 : $0 < $1 }) + [AddItem(color: self.color)]
        arr = arr.filter{ $0 is Goal || !$0.isFinished && showActive || $0.isFinished && showFinished }
        if arr.count == 1 && !(arr.first is Goal)  {
            arr.removeAll()
        }
        if !showActive && arr.count == 1 {
            arr.removeAll()
        }
        if isCollapsed {
            arr = arr.filter{$0 is Goal}
        }
        return arr 
    }
    
    func duplicated() -> Goal {
        let goal = Goal(title: self.title, description: self.description, color: self.color)
        goal.id = self.id
        for habit in self.habits {
            goal.habits.append(habit.duplicated())
        }
        goal.creationDate = self.creationDate
        goal.isEditMode = self.isEditMode
        goal.isCollapsed = self.isCollapsed
        goal.isFinishedConfirmationShown = self.isFinishedConfirmationShown
        return goal
    }
    
    // MARK: - Habits management
    
    func withHabitsSorted() -> Goal {
        let latestFirst: Bool = defaults.bool(forKey: sortLatestFirstKey)
        let sortedActive = habits.filter{!$0.isFinished}.sorted(by: { latestFirst ? $0 > $1 : $0 < $1 })
        let sortedFinished = habits.filter{$0.isFinished}.sorted(by: { latestFirst ? $0 > $1 : $0 < $1 })
        self.habits = sortedActive + sortedFinished
        return self
    }
    
    func withHabitAdded(habit: Habit?) -> Goal {
        let appropriateIndex = defaults.bool(forKey: sortLatestFirstKey) ? 0 : habits.filter{ !$0.isFinished }.count
        if let habit = habit {
            habits.insert(habit, at: appropriateIndex)
        }
        else {
            habits.insert(Habit(trigger: "", badHabit: "", goodHabit: "", color: self.color, goalID: self.id, goalTitle: self.title), at: appropriateIndex)
        }
        habits[appropriateIndex].goalID = self.id
        newHabitIndex = appropriateIndex + 1
        return self
    }
    
    func withHabitChanged(habit: Habit) -> Goal {
        habits = habits.map { $0.id == habit.id ? habit : $0 }
        return self
    }
    
    func withHabitRemoved(habit: Habit) -> Goal {
        habits = habits.filter { $0.id != habit.id }
        return self
    }
    
    func hasItemWithID(id: UInt32) -> Bool {
        return !habits.filter { $0.hasItemWithID(id: id) }.isEmpty
    }
    
    func habitWithID(id: UInt32) -> Habit {
        return habits.filter { $0.id == id }.first!
    }
    // MARK: - Buffering
    
    struct BufferGoal: Codable {
        var title: String
        var description: String
    }
    
    func buffer() {
        bufferGoal = BufferGoal(title: self.title, description: self.description)
        isEditMode = true
    }
    
    func restoreFromBuffer() {
        if let bufferGoal = self.bufferGoal {
            self.title = bufferGoal.title
            self.description = bufferGoal.description
        }
        self.isEditMode = false
        self.bufferGoal = nil
    }
    
    // MARK: - History
    
    var globalHistoryInterfaceArray: [FeedItem] {
        let showNotes = defaults.bool(forKey: showNotesKey)
        let showBad = defaults.bool(forKey: showBadCheckInsKey)
        let showGood = defaults.bool(forKey: showGoodCheckInsKey)
        let items = habits.map{$0.historyInterfaceArray}.reduce([FeedItem]()) {$0 + $1}
        var notes = [FeedItem]()
        var bad = [FeedItem]()
        var good = [FeedItem]()
        if showNotes {
            notes = items.filter{$0.type == .note}
        }
        if showBad {
            bad = items.filter{$0.type == .badCheckIn}
        }
        if showGood {
            good = items.filter{$0.type == .goodCheckIn}
        }
        let array = notes + bad + good
        return array.sorted(by: >)
    }
    
    var showNote: Bool = true
    var showBadHabits: Bool = true
    var showGoodHabits: Bool = true
    
    var selfHistoryInterfaceArray: [FeedItem] {
        let items = habits.map{$0.historyInterfaceArray}.reduce([FeedItem]()) {$0 + $1}
        var notes = [FeedItem]()
        var bad = [FeedItem]()
        var good = [FeedItem]()
        if showNote {
            notes = items.filter{$0.type == .note}
        }
        if showBadHabits {
            bad = items.filter{$0.type == .badCheckIn}
        }
        if showGoodHabits {
            good = items.filter{$0.type == .goodCheckIn}
        }
        let array = notes + bad + good
        return array.sorted(by: >)
    }
    
    // MARK: - Statistics
    
    func allCheckIns() -> [CheckIn] {
        var array = [CheckIn]()
        for habit in habits {
            array.append(contentsOf: habit.checkIns)
        }
        return array
    }
    
    var daysSinceGoalWasSet: Int {
        let startDateStart = Calendar.current.dateInterval(of: .day, for: self.creationDate)!.start
        let numberOfDays = Calendar.current.dateComponents([.day], from: startDateStart, to: Date()).day! + 1
        return numberOfDays
    }
    
    var daysOfWorkingOnTheGoal: StatisticsItem {
        let number = daysSinceGoalWasSet
        let day = "day".pluralizedOrNotForNumber(number: number)
        let text = "\(day) since the goal was set"
        return StatisticsItem(number: number, text: text)
    }
    
    var numberOfTriggers: StatisticsItem {
        let number = habits.count
        let trigger = "trigger".pluralizedOrNotForNumber(number: number)
        let text = "\(trigger) detected"
        return StatisticsItem(number: number, text: text)
    }
    
    var numberOfFinished: StatisticsItem {
        let number = habits.filter{$0.isFinished}.count
        let habit = "habit".pluralizedOrNotForNumber(number: number)
        let text = "bad \(habit) beaten"
        return StatisticsItem(number: number, text: text)
    }
    
    var totalProgress: StatisticsItem {
        let number = habits.map{$0.progress}.reduce(0){$0 + $1}
        let step = "step".pluralizedOrNotForNumber(number: number)
        let text = "\(step) forward on the path of self-improvement"
        return StatisticsItem(number: number, text: text)
    }
    
    var goodCheckIns: StatisticsItem {
        let number = allCheckIns().filter{$0.habitType == .good}.count
        let decision = "decision".pluralizedOrNotForNumber(number: number)
        let text = "right \(decision) made"
        return StatisticsItem(number: number, text: text)
    }
    
    var badCheckIns: StatisticsItem {
        let number = allCheckIns().filter{$0.habitType == .bad}.count
        let time = "time".pluralizedOrNotForNumber(number: number)
        let text = "\(time) the ingrained habits took over"
        return StatisticsItem(number: number, text: text)
    }
    
    var notesWritten: StatisticsItem {
        let number = habits.map{$0.notes.count}.reduce(0){$0 + $1}
        let thought = "thought".pluralizedOrNotForNumber(number: number)
        let andOr = number == 1 ? "or" : "and"
        let insight = "insight".pluralizedOrNotForNumber(number: number)
        let text = "\(thought) \(andOr) \(insight) written down"
        return StatisticsItem(number: number, text: text)
    }
    
    var statisticsItems: [StatisticsItem] {
        return [daysOfWorkingOnTheGoal, numberOfTriggers, numberOfFinished, goodCheckIns, badCheckIns, notesWritten]
    }
    
    func progressOn(date: Date) -> Int {
        return habits.map{$0.progressOn(date: date)}.reduce(0){$0 + $1}
    }
    
    func progressAtHour(date: Date, hour: Int) -> Int {
        return habits.map{$0.progressAtHour(date: date, hour: hour)}.reduce(0){$0 + $1}
    }

    func goodCheckInsOn(date: Date) -> Int {
        return habits.map{$0.goodCheckInsOn(date: date)}.reduce(0){$0 + $1}
    }

    func goodCheckInsAtHour(date: Date, hour: Int) -> Int {
        return habits.map{$0.goodCheckInsAtHour(date: date, hour: hour)}.reduce(0){$0 + $1}
    }
    
    func badCheckInsOn(date: Date) -> Int {
        return habits.map{$0.badCheckInsOn(date: date)}.reduce(0){$0 + $1}
    }
    
    func badCheckInsAtHour(date: Date, hour: Int) -> Int {
        return habits.map{$0.badCheckInsAtHour(date: date, hour: hour)}.reduce(0){$0 + $1}
    }
    
// MARK: - Saving and validation
    
    func areStringsValid() -> Bool {
        return self.title != "" && self.title != Goal.titlePlaceholder && self.description != "" && self.description != Goal.descriptionPlaceholder
    }
    
    func removeCarriageReturns() {
        self.title.removeCarriageReturns()
        self.description.removeCarriageReturns()
    }
    
    func saveChanges() {
        self.removeCarriageReturns()
        self.isEditMode = false
        self.bufferGoal = nil
    }
    
    // MARK: - Coding and encoding
    
    static var documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static var ArchiveURL = documentsDirectory.appendingPathComponent("goals").appendingPathExtension("plist")
    static func saveToFile(goals: [Goal]) {
        let propertyListEncoder = PropertyListEncoder()
        let encodedGoal = try? propertyListEncoder.encode(goals)
        try? encodedGoal?.write(to: ArchiveURL, options: .noFileProtection)
    }
    static func loadFromFile() -> [Goal]? {
        let propertyListDecoder = PropertyListDecoder()
        guard let retrievedGoalsData = try? Data(contentsOf: ArchiveURL) else { return nil }
        return try? propertyListDecoder.decode(Array<Goal>.self, from: retrievedGoalsData)
    }
    // MARK: - Comparable
    
    static func < (lhs: Goal, rhs: Goal) -> Bool {
        return lhs.creationDate < rhs.creationDate
    }
    
    static func == (lhs: Goal, rhs: Goal) -> Bool {
        lhs.creationDate == rhs.creationDate
    }
}
