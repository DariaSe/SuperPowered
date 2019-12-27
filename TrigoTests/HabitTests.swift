//
//  HabitTests.swift
//  TrigoTests
//
//  Created by Дарья Селезнёва on 03/10/2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import XCTest

@testable import Trigo

class HabitTests: XCTestCase {
    
    var habit: Habit!

    override func setUp() {
        super.setUp()
        habit = Habit(trigger: "Trigger", badHabit: "BH", goodHabit: "GH")
    }

    override func tearDown() {
        habit = nil
        super.tearDown()
    }

    func testProgressCreation() {
        habit.addCheckIn(habitType: .good)
        habit.addCheckIn(habitType: .good)
        habit.addCheckIn(habitType: .bad)
        habit.addCheckIn(habitType: .good)
        XCTAssertTrue(habit.progress == 1)
    }
    
    func testCurrentSerieCreationWhenBadIsLast() {
        habit.addCheckIn(habitType: .good)
        habit.addCheckIn(habitType: .good)
        habit.addCheckIn(habitType: .bad)
        habit.addCheckIn(habitType: .good)
        habit.addCheckIn(habitType: .bad)
        XCTAssertTrue(habit.currentSerie == 0)
    }
    
    func testCurrentSerieCreation() {
        habit.addCheckIn(habitType: .good)
        habit.addCheckIn(habitType: .good)
        habit.addCheckIn(habitType: .bad)
        habit.addCheckIn(habitType: .good)
        habit.addCheckIn(habitType: .good)
        XCTAssertTrue(habit.currentSerie == 2)
        
        habit.addCheckIn(habitType: .bad)
        XCTAssert(habit.currentSerie == 0)
    }
    
    func testCheckInCancelling() {
        habit.addCheckIn(habitType: .good)
        habit.addCheckIn(habitType: .good)
        habit.addCheckIn(habitType: .bad)
        habit.addCheckIn(habitType: .good)
        habit.addCheckIn(habitType: .good)
        habit.cancelLastCheckIn(habitType: .good)
        XCTAssertTrue(habit.progress == 1, "1+1-2+1+1-1 = 1")
        
        habit.cancelLastCheckIn(habitType: .bad)
        XCTAssertFalse(habit.progress == 0)
    }
    
    func testMaximalSerieEstimating() {
        habit.addCheckIn(habitType: .bad)
        habit.addCheckIn(habitType: .good)
        habit.addCheckIn(habitType: .good)
        XCTAssertTrue(habit.maximalSerie == 2)
        
        habit.addCheckIn(habitType: .bad)
        XCTAssert(habit.currentSerie == 0)
        XCTAssert(habit.maximalSerie == 2)
    }

}
