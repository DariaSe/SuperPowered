//
//  extension String.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 08/10/2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

extension String {
    mutating func removeCarriageReturns() {
        for character in self {
            if character == "\n" {
                self.removeFirst()
            }
            else {
                break
            }
        }
        for _ in self {
            if let lastCharacter = self.last {
                if lastCharacter == "\n" {
                    self.removeLast()
                }
            }
        }
    }
    
    func pluralized() -> String {
        return self + "s"
    }
    
    func pluralizedOrNotForNumber(number: Int) -> String {
        if number == 1 {
            return self
        }
        else {
            return self.pluralized()
        }
    }
}
