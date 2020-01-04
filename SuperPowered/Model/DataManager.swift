//
//  DataManager.swift
//  SuperPowered
//
//  Created by Дарья Селезнёва on 31.12.2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import Foundation
import CloudKit

class DataManager {
    
    var database = CKContainer.default().privateCloudDatabase
    
    var goalRecords: [CKRecord] = []
    var habitRecords: [CKRecord] = []
    var checkInRecords: [CKRecord] = []
    var noteRecords: [CKRecord] = []
    
    var goals: [Goal] = []
    var habits: [Habit] = []
    var checkIns: [CheckIn] = []
    var notes: [Note] = []
    
    
    // MARK: - Querying
    
    let goalsHabitsDispatchGroup = DispatchGroup()
    let checkInsNotesDispatchGroup = DispatchGroup()
    
    func fetchAll(completion: @escaping ([Goal]) -> ()) {
        fetchGoals()
        fetchHabits()
        goalsHabitsDispatchGroup.notify(queue: .main) {
            self.fetchCheckIns()
            self.fetchNotes()
            self.checkInsNotesDispatchGroup.notify(queue: .main) {
                self.setHabits()
                completion(self.goals)
            }
        }
    }
    
    func fetchGoals() {
        goalsHabitsDispatchGroup.enter()
        let goalQuery = CKQuery(recordType: "Goal", predicate: NSPredicate(value: true))
        database.perform(goalQuery, inZoneWith: nil) { (records, error) in
            if error != nil {
                print(error as Any)
            }
            else {
                guard let records = records else { return }
                self.goalRecords = records
                self.goals = records.map{$0.goal}
                self.goalsHabitsDispatchGroup.leave()
            }
        }
    }
    
    func fetchHabits() {
        goalsHabitsDispatchGroup.enter()
        let habitQuery = CKQuery(recordType: "Habit", predicate: NSPredicate(value: true))
        database.perform(habitQuery, inZoneWith: nil) { (records, error) in
            if error != nil {
                print(error as Any)
            }
            else {
                guard let records = records else { return }
                self.habitRecords = records
                self.habits = self.habitRecords.map{$0.habit}
                self.goalsHabitsDispatchGroup.leave()
            }
        }
    }
    
    func fetchCheckIns() {
        checkInsNotesDispatchGroup.enter()
        let checkInQuery = CKQuery(recordType: "CheckIn", predicate: NSPredicate(value: true))
        database.perform(checkInQuery, inZoneWith: nil) { (records, error) in
            if error != nil {
                print(error as Any)
            }
            else {
                guard let records = records else { return }
                self.checkInRecords = records
                self.checkIns = self.checkInRecords.map{ $0.checkIn }
                for habit in self.habits {
                    habit.checkIns = self.checkIns.filter{$0.habitID == habit.id}
                }
                self.checkInsNotesDispatchGroup.leave()
            }
        }
    }
    
    func fetchNotes() {
        checkInsNotesDispatchGroup.enter()
        let noteQuery = CKQuery(recordType: "Note", predicate: NSPredicate(value: true))
        database.perform(noteQuery, inZoneWith: nil) { (records, error) in
            if error != nil {
                print(error as Any)
            }
            else {
                guard let records = records else { return }
                self.noteRecords = records
                self.notes = self.noteRecords.map{ $0.note }
                for habit in self.habits {
                    habit.notes = self.notes.filter{$0.habitID == habit.id}
                }
                self.checkInsNotesDispatchGroup.leave()
            }
        }
    }
    
    func setHabits() {
        for goal in goals {
            goal.habits = habits.filter{ $0.goalID == goal.id }
        }
    }
    
    init() {
        fetchAll { _ in }
    }
    
    // MARK: - Saving
    
    func hasGoal(with id: UInt32) -> Bool {
        return !goalRecords.filter{$0[.id] as! UInt32 == id}.isEmpty
    }
    
    func save(goal: Goal) {
        if hasGoal(with: goal.id) {
            var goalRecord = goalRecords.filter{$0[.id] as! UInt32 == goal.id}.first!
            goalRecord = goal.preparedForCloud(record: goalRecord)
            database.save(goalRecord) { (record, error) in
                if error != nil {
                    print(error as Any)
                }
                print(record?[.title] as Any)
            }
        }
        else {
            let newRecord = goal.preparedForCloud(record: nil)
            goalRecords.append(newRecord)
            database.save(newRecord) { (record, error) in
                if error != nil {
                    print(error as Any)
                }
                print(record?[.title] as Any)
            }
        }
    }
    
    func delete(goal: Goal) {
        let goalRecord = goalRecords.filter{$0[.id] as! UInt32 == goal.id}.first!
        database.delete(withRecordID: goalRecord.recordID) { (id, error) in
            print(id as Any)
            if error == nil {
                self.goalRecords = self.goalRecords.filter{$0.recordID != goalRecord.recordID}
            }
        }
    }
    
    func hasHabit(with id: UInt32) -> Bool {
        return !habitRecords.filter{$0[.id] as! UInt32 == id}.isEmpty
    }
    
    func save(habit: Habit) {
        if hasHabit(with: habit.id) {
            var habitRecord = habitRecords.filter{$0[.id] as! UInt32 == habit.id}.first!
            habitRecord = habit.preparedForCloud(record: habitRecord)
            database.save(habitRecord) { (record, error) in
                if error != nil {
                    print(error as Any)
                }
                print(record?[.trigger] as Any)
            }
        }
        else {
            let newRecord = habit.preparedForCloud(record: nil)
            habitRecords.append(newRecord)
            database.save(newRecord) { (record, error) in
                if error != nil {
                    print(error as Any)
                }
                print(record?[.trigger] as Any)
            }
        }
    }
    
    func delete(habit: Habit) {
        let habitRecord = habitRecords.filter{$0[.id] as! UInt32 == habit.id}.first!
        database.delete(withRecordID: habitRecord.recordID) { (id, error) in
            print(id as Any)
            if error == nil {
                self.habitRecords = self.habitRecords.filter{$0.recordID != habitRecord.recordID}
            }
        }
    }
    
    func hasCheckIn(with id: UInt32) -> Bool {
        return !checkInRecords.filter{$0[.id] as! UInt32 == id}.isEmpty
    }
    
    func save(checkIn: CheckIn) {
        if hasCheckIn(with: checkIn.id) {
            var checkInRecord = checkInRecords.filter{$0[.id] as! UInt32 == checkIn.id}.first!
            checkInRecord = checkIn.preparedForCloud(record: checkInRecord)
            database.save(checkInRecord) { (record, error) in
                if error != nil {
                    print(error as Any)
                }
                print(record?[.text] as Any)
            }
        }
        else {
            let newRecord = checkIn.preparedForCloud(record: nil)
            checkInRecords.append(newRecord)
            database.save(newRecord) { (record, error) in
                if error != nil {
                    print(error as Any)
                }
                print(record?[.text] as Any)
            }
        }
    }
    
    func delete(checkIn: CheckIn) {
        let checkInRecord = checkInRecords.filter{$0[.id] as! UInt32 == checkIn.id}.first!
        database.delete(withRecordID: checkInRecord.recordID) { (id, error) in
            print(id as Any)
            if error == nil {
                self.checkInRecords = self.checkInRecords.filter{$0.recordID != checkInRecord.recordID}
                print(self.checkInRecords)
            }
        }
    }
    
}

extension CKRecord {
    
    var goal: Goal {
        guard self.recordType == "Goal" else { fatalError("Can not convert this record into a Goal") }
        let title = self[.title] as! String
        let description = self[.description] as! String
        let color = self[.color] as! Int
        
        let goal = Goal(title: title, description: description, color: color)
        
        goal.id = self[.id] as! UInt32
        goal.creationDate = self[.date] as! Date
        
        goal.isEditMode = false
        goal.isCollapsed = (self[.isCollapsed] as! Int).bool
        goal.isFinishedConfirmationShown = (self[.isFinishedConfirmationShown] as! Int).bool
        
        goal.showNote = (self[.showNote] as! Int).bool
        goal.showBadHabits = (self[.showBad] as! Int).bool
        goal.showGoodHabits = (self[.showGood] as! Int).bool
        
        return goal
    }
    
    var habit: Habit {
        guard self.recordType == "Habit" else { fatalError("Can not convert this record into a Habit") }
        let trigger = self[.trigger] as! String
        let badHabit = self[.badHabit] as! String
        let goodHabit = self[.goodHabit] as! String
        let color = self[.color] as! Int
        let goalID = self[.goalID] as! UInt32
        let goalTitle = self[.goalTitle] as! String
        
        let habit = Habit(trigger: trigger, badHabit: badHabit, goodHabit: goodHabit, color: color, goalID: goalID, goalTitle: goalTitle)
        
        habit.isEditMode = false
        habit.id = self[.id] as! UInt32
        habit.creationDate = self[.date] as! Date
        
        return habit
    }
    
    var checkIn: CheckIn {
        guard self.recordType == "CheckIn" else { fatalError("Can not convert this record into a CheckIn") }
        let text = self[.text] as! String
        let triggerText = self[.triggerText] as! String
        let type = HabitType(rawValue: self[.habitType] as! Int)!
        let habitID = self[.habitID] as! UInt32
        
        let checkIn = CheckIn(habitID: habitID, text: text, triggerText: triggerText, habitType: type)
        
        checkIn.id = self[.id] as! UInt32
        checkIn.date = self[.date] as! Date
        
        return checkIn
    }
    
    var note: Note {
        guard self.recordType == "Note" else { fatalError("Can not convert this record into a Note") }
        let text = self[.text] as! String
        let triggerText = self[.triggerText] as! String
        let habitID = self[.habitID] as! UInt32
        
        let note = Note(habitID: habitID, text: text, triggerText: triggerText)
        
        note.id = self[.id] as! UInt32
        note.date = self[.date] as! Date
        
        return note
    }
}
