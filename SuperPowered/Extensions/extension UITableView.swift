//
//  extension UITableView.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 05/10/2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

extension UITableView {
    func updateToFit(from textViewText: String, to property: inout String) {
            property = textViewText
            DispatchQueue.main.async {
                self.beginUpdates()
                self.endUpdates()
            }
        }
    }
