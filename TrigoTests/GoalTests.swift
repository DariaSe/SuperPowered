//
//  GoalTests.swift
//  TrigoTests
//
//  Created by Дарья Селезнёва on 03/10/2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import XCTest

@testable import Trigo

class GoalTests: XCTestCase {
    
    var goal: Goal!

    override func setUp() {
        super.setUp()
        goal = Goal(title: "Test title", description: "Test description", color: 3)
    }

    override func tearDown() {
        goal = nil
        super.tearDown()
    }

    func testInterfaceArrayCreationWhenExpanded() {
        goal.habits.append(Habit(goalID: goal.id, trigger: "Trigger", badHabit: "BH", goodHabit: "GH", color: goal.color))
        goal.isCollapsed = false
        XCTAssertTrue(goal.interfaceArray.count == 3, "Goal creates an interface array with 3 elements: self, habit and addButton")
    }
    
    func testInterfaceArrayCreationWhenCollapsed() {
        goal.habits.append(Habit(goalID: goal.id, trigger: "Trigger", badHabit: "BH", goodHabit: "GH", color: goal.color))
        goal.isCollapsed = true
        XCTAssertTrue(goal.interfaceArray.count == 1, "Goal creates an interface array with 1 element: only self")
    }
}
