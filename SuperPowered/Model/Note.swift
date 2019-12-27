//
//  Note.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 02/10/2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import Foundation

class Note: Codable, IDValidator {
    var id: UInt32 = arc4random()
    var text: String
    var triggerText: String
    var date: Date = Date()
    
    init(text: String, triggerText: String) {
        self.text = text
        self.triggerText = triggerText
    }
    
    static let placeholder = "Add a note..."
    
    func withTextChanged(text: String) -> Note {
        self.text = text
        return self
    }
    
    static func from(feedItem: FeedItem) -> Note {
        let note = Note(text: feedItem.text, triggerText: feedItem.triggerText)
        note.date = feedItem.creationDate
        note.id = feedItem.id
        return note
    }
}
