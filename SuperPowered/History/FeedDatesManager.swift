//
//  FeedDatesManager.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 18.12.2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

class FeedDatesManager {
    var feedItems: [FeedItem] = []
    
    var feedItemsDivided: [[FeedItem]]  {
        var array = [[FeedItem]]()
        guard !feedItems.isEmpty else { return array }
        let startDate = feedItems.first!.creationDate.dayStart()
        let endDate = feedItems.last!.creationDate.dayStart()
        guard let daysBetween = Calendar.current.dateComponents([.day], from: endDate, to: startDate).day else { return array }
        
        var date = startDate
        for _ in 0...daysBetween {
            let subArray = feedItems.filter{$0.creationDate.dayStart() == date}
            if !subArray.isEmpty {
            array.append(subArray)
            }
            date = date.addingTimeInterval(-86400)
        }
        return array
    }
    
    var dateSignatures: [String] {
        var strArray: [String] = []
        for array in feedItemsDivided {
            if let date = array.first?.creationDate.dayStart() {
                if date == Date().dayStart() {
                    strArray.append("Today")
                }
                else if date == Date().dayStart().addingTimeInterval(-86400) {
                    strArray.append("Yesterday")
                }
                else {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateStyle = .long
                    dateFormatter.timeStyle = .none
                    let string = dateFormatter.string(from: date)
                    strArray.append(string)
                }
            }
        }
        return strArray
    }
}
