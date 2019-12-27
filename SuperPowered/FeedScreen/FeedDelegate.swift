//
//  FeedDelegate.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 18.12.2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

protocol FeedDelegate {
    var goals: [Goal] { get set }
    func addNote(note: Note)
    mutating func editItemText(replaceWith text: String, id: UInt32)
    mutating func deleteItem(with id: UInt32)
    func reload()
}

extension FeedDelegate {
    func addNote(note: Note) {
        
    }
    
    mutating func editItemText(replaceWith text: String, id: UInt32) {
        let goal = goals.filter{$0.hasItemWithID(id: id)}.first
        let habit = goal?.habits.filter{$0.hasItemWithID(id: id)}.first
        if let goal = goal, let habit = habit {
            habit.notes = habit.notes.map { $0.id == id ? $0.withTextChanged(text: text) : $0 }
            habit.checkIns = habit.checkIns.map { $0.id == id ? $0.withTextChanged(text: text) : $0 }
            goals = goals.map { $0.id == goal.id ? $0.withHabitChanged(habit: habit) : $0 }
            Goal.saveToFile(goals: goals)
            reload()
        }
    }
    
    mutating func deleteItem(with id: UInt32) {
        let goal = goals.filter{$0.hasItemWithID(id: id)}.first
        let habit = goal?.habits.filter{$0.hasItemWithID(id: id)}.first
        if let goal = goal, let habit = habit {
            habit.checkIns = habit.checkIns.filter { $0.id != id }
            habit.notes = habit.notes.filter { $0.id != id }
            goals = goals.map { $0.id == goal.id ? $0.withHabitChanged(habit: habit) : $0 }
            Goal.saveToFile(goals: goals)
            reload()
        }
    }
}

