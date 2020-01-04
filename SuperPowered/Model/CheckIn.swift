//
//  CheckIn.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 02/10/2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import Foundation
import CloudKit

enum HabitType: Int, Codable {
    case bad
    case good
}

class CheckIn: Codable, Comparable, IDValidator {
    
    var id: UInt32 = arc4random()
    var habitID: UInt32
    var date: Date = Date()
    var text: String
    var triggerText: String
    var habitType: HabitType
    
    init(habitID: UInt32, text: String, triggerText: String, habitType: HabitType) {
        self.habitID = habitID
        self.text = text
        self.habitType = habitType
        self.triggerText = triggerText
    }
    
    func withTextChanged(text: String) -> CheckIn {
        self.text = text
        return self
    }
    
    enum CodingKeys: CodingKey {
        case date, text, triggerText, habitType, habitID
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(date, forKey: .date)
        try container.encode(text, forKey: .text)
        try container.encode(triggerText, forKey: .triggerText)
        try container.encode(habitType, forKey: .habitType)
        try container.encode(habitID, forKey: .habitID)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        date = try container.decode(Date.self, forKey: .date)
        habitType = try container.decode(HabitType.self, forKey: .habitType)
        text = try container.decode(String.self, forKey: .text)
        triggerText = try container.decode(String.self, forKey: .triggerText)
        habitID = try container.decode(UInt32.self, forKey: .habitID)
    }
    
    static func == (lhs: CheckIn, rhs: CheckIn) -> Bool {
        return lhs.date == rhs.date
    }
    
    static func < (lhs: CheckIn, rhs: CheckIn) -> Bool {
        return lhs.date < rhs.date
    }
    
    func preparedForCloud(record: CKRecord?) -> CKRecord {
        var recordToSave: CKRecord
        if let record = record {
            recordToSave = record
        }
        else {
            recordToSave = CKRecord(recordType: "CheckIn")
        }
        recordToSave[.text] = text
        recordToSave[.triggerText] = triggerText
        recordToSave[.habitType] = habitType.rawValue
        recordToSave[.date] = date
        recordToSave[.id] = id
        recordToSave[.habitID] = habitID
        
        return recordToSave
    }
    
//    static func fromRecord(record: CKRecord) -> CheckIn {
//        let text = record[.text] as! String
//        let triggerText = record[.triggerText] as! String
//        let type = HabitType(rawValue: record[.habitType] as! Int)!
//        let habitID = record[.habitID] as! UInt32
//        
//        let checkIn = CheckIn(habitID: habitID, text: text, triggerText: triggerText, habitType: type)
//        
//        checkIn.id = record[.id] as! UInt32
//        checkIn.date = record[.date] as! Date
//        
//        return checkIn
//    }
}

enum CheckInKey: String {
    case text, triggerText, habitType, habitID
}

extension CKRecord {
    subscript(key: CheckInKey) -> Any? {
        get {
            return self[key.rawValue]
        }
        set {
            self[key.rawValue] = newValue as? CKRecordValue
        }
    }
}
