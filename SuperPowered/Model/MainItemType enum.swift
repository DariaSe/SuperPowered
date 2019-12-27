//
//  MainScreenModel.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 02/10/2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import Foundation

enum MainItemType {
    case goal(Goal)
    case habit(Habit)
    case addButton(AddItem)
}

protocol MainItem {
    var id: UInt32 { get set }
    var itemType: MainItemType { get }
    var isFinished: Bool { get }
}

class AddItem: MainItem {
    var id: UInt32
    var itemType: MainItemType {
        return .addButton(self)
    }
    var isFinished: Bool {
        return false
    }
    var color: Int
    init(color: Int) {
        self.id = 0
        self.color = color
    }
}

