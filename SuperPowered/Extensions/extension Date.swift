//
//  extension Date.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 11/10/2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

extension Date {
    
    func textForFeedScreen() -> String {
        let timeInterval = Calendar.current.dateComponents([.second], from: self, to: Date())
        let seconds = timeInterval.second!
        let dateComponents = Calendar.current.dateComponents([.day, .month, .hour,.minute], from: self)
        let hour = dateComponents.hour!
        let minute = dateComponents.minute!
        let day = dateComponents.day!
        let month = dateComponents.month!
        
        var text: String = ""
        
        switch seconds {
        case 0:
            text = "right now"
        case 1:
            text = "\(seconds) second ago"
        case 2...59:
            text = "\(seconds) seconds ago"
        case 60...3599:
            let minutes = Int(round(Float(seconds / 60)))
            if minutes == 1 {
                text = "\(minutes) minute ago"
            }
            else {
                text = "\(minutes) minutes ago"
            }
        case 3600...14400:
            let hours = Int(round(Float(seconds / 3600)))
            if hours == 1 {
                text = "\(hours) hour ago"
            }
            else {
                text = "\(hours) hours ago"
            }
        default:
            var date = ""
            var time = ""
            if month <= 9 {
                date = "\(day).0\(month)"
            }
            else {
                date = "\(day).\(month)"
            }
            if minute <= 9 {
                time = "\(hour):0\(minute)"
            }
            else {
                time = "\(hour):\(minute)"
            }
            text = "\(date) at \(time)"
        }
        return text
    }
    
    func forCurrentTimeZone() -> Date {
        return self.addingTimeInterval(TimeInterval(Calendar.current.timeZone.secondsFromGMT()))
    }
    
    func dayStart() -> Date {
        return (Calendar.current.dateInterval(of: .day, for: self)?.start)!
    }
    
    func start(of component: Calendar.Component) -> Date? {
        return Calendar.current.dateInterval(of: component, for: self)?.start.forCurrentTimeZone()
    }
    
    func end(of component: Calendar.Component) -> Date? {
        let day = Calendar.current.dateInterval(of: component, for: self)?.end.forCurrentTimeZone()
        let lastDay = Calendar.current.date(byAdding: .day, value: -1, to: day!)
        return lastDay
    }
    
    
}
// MARK: - Calendar Components shorthand

extension Date {
    var hour: Int {
        Calendar.current.component(.hour, from: self)
    }
    var day: Int {
        Calendar.current.component(.day, from: self)
    }
    var month: Int {
        Calendar.current.component(.month, from: self)
    }
    var year: Int {
        Calendar.current.component(.year, from: self)
    }
    var dayFormat: String {
        String(self.day).count == 1 ? "d" : "dd"
    }
}
