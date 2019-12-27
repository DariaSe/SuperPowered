//
//  IDValidator.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 10.12.2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import Foundation

protocol IDValidator {
    var id: UInt32 { get set }
    mutating func validateID()
}

extension IDValidator {
    mutating func validateID() {
        if var IDs = defaults.object(forKey: IDsKey) as? Array<UInt32> {
            while IDs.contains(self.id) {
            self.id = arc4random()
            }
            IDs.append(self.id)
            defaults.set(IDs, forKey: IDsKey)
        }
    }
}
