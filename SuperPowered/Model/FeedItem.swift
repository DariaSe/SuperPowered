//
//  FeedItem.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 11/10/2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import Foundation

enum FeedItemType: Int, Codable {
    case badCheckIn
    case goodCheckIn
    case note
}

struct FeedItem: Codable, Comparable, IDValidator {
    
    // MARK: - Properties
    
    var type: FeedItemType
    var id: UInt32
    
    var text: String
    var triggerText: String
    var isExpanded: Bool = false
    
    var creationDate: Date
    var editingDate: Date?
    
    var color: Int?
    
    var isEditMode: Bool = false
    
    // MARK: - Init
    
    init(triggerText: String, text: String, date: Date, type: FeedItemType, id: UInt32, color: Int?) {
        self.triggerText = triggerText
        self.text = text
        self.creationDate = date
        self.type = type
        self.id = id
        self.color = color
    }
    
    // MARK: - Comparable
    
    static func == (lhs: FeedItem, rhs: FeedItem) -> Bool {
        return lhs.creationDate == rhs.creationDate
    }
    
    static func < (lhs: FeedItem, rhs: FeedItem) -> Bool {
        return lhs.creationDate < rhs.creationDate
    }
}
