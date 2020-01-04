//
//  Note.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 02/10/2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import Foundation
import CloudKit

class Note: Codable, IDValidator {
    var id: UInt32 = arc4random()
    var habitID: UInt32
    var text: String
    var triggerText: String
    var date: Date = Date()
    
    init(habitID: UInt32, text: String, triggerText: String) {
        self.habitID = habitID
        self.text = text
        self.triggerText = triggerText
    }
    
    static let placeholder = "Add a note..."
    
    func withTextChanged(text: String) -> Note {
        self.text = text
        return self
    }
    
    static func from(feedItem: FeedItem) -> Note {
        let note = Note(habitID: 0, text: feedItem.text, triggerText: feedItem.triggerText)
        note.date = feedItem.creationDate
        note.id = feedItem.id
        return note
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
        recordToSave[.date] = date
        recordToSave[.id] = id
        
        return recordToSave
    }
    
//    static func fromRecord(record: CKRecord) -> Note {
//        let text = record[.text] as! String
//        let triggerText = record[.triggerText] as! String
//
//        let note = Note(text: text, triggerText: triggerText)
//
//        note.id = record[.id] as! UInt32
//        note.date = record[.date] as! Date
//
//        return note
//    }
}
