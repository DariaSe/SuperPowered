//
//  ChartManager.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 23.11.2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

class ChartManager {
    var goals: [Goal]?
    var goal: Goal?
    var habit: Habit?
    
    // MARK: - Dates
    
    var calendarIntervalSelected: CalendarInterval {
        return CalendarInterval(rawValue: defaults.integer(forKey: calendarIntervalKey))!
    }
    var calendarComponentToUse: Calendar.Component {
        switch calendarIntervalSelected {
        case .day:
            return .day
        case .week:
            return .weekOfYear
        case .month:
            return .month
        }
    }
    
    var intervalsBackwardFromNow: Int = 0
    
    var baseDate: Date {
        Calendar.current.date(byAdding: calendarComponentToUse, value: -intervalsBackwardFromNow, to: Date())!
    }
    
    var firstIntervalDay: Date {
        baseDate.start(of: calendarComponentToUse)!
    }
    
    var lastIntervalDay: Date {
        baseDate.end(of: calendarComponentToUse)!
    }
    
    var intervalLength: Int {
        switch calendarComponentToUse {
        case .day:
            return 24
        case .weekOfYear:
            return 7
        case .month:
            return Calendar.current.range(of: .day, in: calendarComponentToUse, for: baseDate)!.count
        default:
            return 0
        }
    }
    
    var intervalTextRepresentation: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        var text = ""
        switch calendarComponentToUse {
            
        case .day:
            if intervalsBackwardFromNow == 0 {
                text = "Today"
            }
            else if intervalsBackwardFromNow == 1 {
                text = "Yesterday"
            }
            else {
                dateFormatter.dateStyle = .long
                text = dateFormatter.string(from: baseDate)
            }
            
        case .weekOfYear:
            let weekStartMonthFormat = firstIntervalDay.month == lastIntervalDay.month ? "" : " LLL"
            dateFormatter.dateFormat = firstIntervalDay.dayFormat + weekStartMonthFormat
            let startString = dateFormatter.string(from: firstIntervalDay)
            dateFormatter.dateFormat = lastIntervalDay.dayFormat + " LLL"
            let endString = dateFormatter.string(from: lastIntervalDay)
            
            let weekStartYear = String(firstIntervalDay.year)
            let weekEndYear = String(lastIntervalDay.year)
            
            let startYear = weekStartYear != weekEndYear ? (" " + weekStartYear) : ""
            let endYear = " " + weekEndYear
            
            text = startString + startYear + " - " + endString + endYear
            
        case .month:
            let months = dateFormatter.monthSymbols
            let month = baseDate.month
            let year = baseDate.year
            text = "\(months![month - 1]) \(year)"
            
        default:
            break
        }
        return text
    }
    
    var intervalSignatures: [String] {
        if calendarComponentToUse == .day {
            var array = [Int]()
            for i in 0...intervalLength - 1 {
                array.append(i)
            }
            array = array.filter{$0 % 2 == 1}
            let stringsArray = array.map{String($0)}
            return stringsArray
        }
        else if calendarComponentToUse == .weekOfYear {
            var array = [String]()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EE"
            for date in intervalDates {
                array.append(dateFormatter.string(from: date))
            }
            return array
        }
        else {
            var array = [Int]()
            for i in 1...intervalLength {
                array.append(i)
            }
            array = array.filter{$0 % 2 == 0}
            let stringsArray = array.map{String($0)}
            return stringsArray
        }
    }
    
    var intervalDates: [Date] {
        if calendarComponentToUse == .day {
            return [baseDate]
        }
        else {
            var array = [Date]()
            var date = firstIntervalDay
            for _ in 1...intervalLength {
                array.append(date)
                date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
            }
            return array
        }
    }
    // MARK: - Progress
    
    var progressArray: [Int] {
        var array = [Int]()
        if intervalDates.count == 1 {
            for hour in 0...(intervalLength - 1) {
                var progress = 0
                if let goals = goals {
                    progress = goals.map{$0.progressAtHour(date: baseDate, hour: hour)}.reduce(0){$0 + $1}
                }
                if let goal = goal {
                    progress = goal.progressAtHour(date: baseDate, hour: hour)
                }
                if let habit = habit {
                    progress = habit.progressAtHour(date: baseDate, hour: hour)
                }
                array.append(progress)
            }
        }
        else {
            for date in intervalDates {
                var progress = 0
                if let goals = goals {
                    progress = goals.map{$0.progressOn(date: date)}.reduce(0){$0 + $1}
                }
                if let goal = goal {
                    progress = goal.progressOn(date: date)
                }
                if let habit = habit {
                    progress = habit.progressOn(date: date)
                }
                array.append(progress)
            }
        }
        return array
    }
    var maxProgress: Int {
        return progressArray.max() ?? 0
    }
    
    var minProgress: Int {
        return progressArray.min() ?? 0
    }
    // MARK: - Good- and BadCheckIns
    
    var goodCheckInsCountsArray: [Int] {
        var array = [Int]()
        if intervalDates.count == 1 {
            for hour in 0...(intervalLength - 1) {
                var checkInsCount = 0
                if let goals = goals {
                    checkInsCount = goals.map{$0.goodCheckInsAtHour(date: baseDate, hour: hour)}.reduce(0){$0 + $1}
                }
                if let goal = goal {
                    checkInsCount = goal.goodCheckInsAtHour(date: baseDate, hour: hour)
                }
                if let habit = habit {
                    checkInsCount = habit.goodCheckInsAtHour(date: baseDate, hour: hour)
                }
                array.append(checkInsCount)
            }
        }
        else {
            for date in intervalDates {
                var checkInsCount = 0
                if let goals = goals {
                    checkInsCount = goals.map{$0.goodCheckInsOn(date: date)}.reduce(0){$0 + $1}
                }
                if let goal = goal {
                    checkInsCount = goal.goodCheckInsOn(date: date)
                }
                if let habit = habit {
                    checkInsCount = habit.goodCheckInsOn(date: date)
                }
                array.append(checkInsCount)
            }
        }
        return array
    }
    var badCheckInsCountsArray: [Int] {
        var array = [Int]()
        if intervalDates.count == 1 {
            for hour in 0...(intervalLength - 1) {
                var checkInsCount = 0
                if let goals = goals {
                    checkInsCount = goals.map{$0.badCheckInsAtHour(date: baseDate, hour: hour)}.reduce(0){$0 + $1}
                }
                if let goal = goal {
                    checkInsCount = goal.badCheckInsAtHour(date: baseDate, hour: hour)
                }
                if let habit = habit {
                    checkInsCount = habit.badCheckInsAtHour(date: baseDate, hour: hour)
                }
                array.append(checkInsCount)
            }
        }
        else {
            for date in intervalDates {
                var checkInsCount = 0
                if let goals = goals {
                    checkInsCount = goals.map{$0.badCheckInsOn(date: date)}.reduce(0){$0 + $1}
                }
                if let goal = goal {
                    checkInsCount = goal.badCheckInsOn(date: date)
                }
                if let habit = habit {
                    checkInsCount = habit.badCheckInsOn(date: date)
                }
                array.append(checkInsCount)
            }
        }
        return array
    }
    
    var maxCheckInsCount: Int {
        return max(goodCheckInsCountsArray.max() ?? 0, badCheckInsCountsArray.max() ?? 0)
    }
    var minCheckInsCount: Int {
        return min(goodCheckInsCountsArray.min() ?? 0, badCheckInsCountsArray.min() ?? 0)
    }
}
