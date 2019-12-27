//
//  TableViewCellDelegate.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 19.10.2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

protocol CellSaveDiscardDelegate {
    func saveChanges(cell: UITableViewCell)
    func discardChanges(cell: UITableViewCell)
}
