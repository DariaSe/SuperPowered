//
//  Global functions.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 02/10/2019.
//  Copyright © 2019 dariaS. All rights reserved.
//
import UIKit

func getCurrentCellIndexPath(view: UIView, in tableView: UITableView) -> IndexPath? {
    let buttonPosition = view.convert(CGPoint.zero, to: tableView)
    if let indexPath: IndexPath = tableView.indexPathForRow(at: buttonPosition) {
        return indexPath
    }
    return nil
}

