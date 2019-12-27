//
//  CheckIn.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 02/10/2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import Foundation

enum HabitType: Int, Codable {
    case bad
    case good
}

class CheckIn: Codable, Comparable, IDValidator {
    
    var id: UInt32 = arc4random()
    var date: Date = Date()
    var text: String
    var triggerText: String
    var habitType: HabitType
    
    init(text: String, triggerText: String, habitType: HabitType) {
        self.text = text
        self.habitType = habitType
        self.triggerText = triggerText
    }
    
    func withTextChanged(text: String) -> CheckIn {
        self.text = text
        return self
    }
    
    enum CodingKeys: CodingKey {
        case date, text, triggerText, habitType
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(date, forKey: .date)
        try container.encode(text, forKey: .text)
        try container.encode(triggerText, forKey: .triggerText)
        try container.encode(habitType, forKey: .habitType)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        date = try container.decode(Date.self, forKey: .date)
        habitType = try container.decode(HabitType.self, forKey: .habitType)
        text = try container.decode(String.self, forKey: .text)
        triggerText = try container.decode(String.self, forKey: .triggerText)
    }
    
    static func == (lhs: CheckIn, rhs: CheckIn) -> Bool {
        return lhs.date == rhs.date
    }
    
    static func < (lhs: CheckIn, rhs: CheckIn) -> Bool {
        return lhs.date < rhs.date
    }
}

