//
//  UserDefaults.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 20.10.2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import Foundation

let defaults = UserDefaults.standard

let showActiveItemsKey = "showActiveItems"
let showFinishedItemsKey = "showFinishedItems"

let sortLatestFirstKey = "sortLatestFirst"

let calendarIntervalKey = "calendarIntervalSelected"

let IDsKey = "IDS"

let showNotesKey = "showNotes"
let showBadCheckInsKey = "showBadHabits"
let showGoodCheckInsKey = "showGoodHabits"

func setDefault() {
    
    if defaults.object(forKey: showActiveItemsKey) == nil {
        defaults.set(true, forKey: showActiveItemsKey)
    }
    if defaults.object(forKey: showFinishedItemsKey) == nil {
        defaults.set(true, forKey: showFinishedItemsKey)
    }
    if defaults.object(forKey: sortLatestFirstKey) == nil {
        defaults.set(false, forKey: sortLatestFirstKey)
    }
    if defaults.object(forKey: calendarIntervalKey) == nil {
        defaults.set(1, forKey: calendarIntervalKey)
    }
    if defaults.object(forKey: IDsKey) == nil {
        let array: [UInt32] = [0]
        defaults.set(array, forKey: IDsKey)
    }
    if defaults.object(forKey: showNotesKey) == nil {
        defaults.set(true, forKey: showNotesKey)
    }
    if defaults.object(forKey: showBadCheckInsKey) == nil {
        defaults.set(true, forKey: showBadCheckInsKey)
    }
    if defaults.object(forKey: showGoodCheckInsKey) == nil {
        defaults.set(true, forKey: showGoodCheckInsKey)
    }
}


