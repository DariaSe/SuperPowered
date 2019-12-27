//
//  Constants.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 03/10/2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height
let minScreenDimension = min(screenWidth, screenHeight)
let edgePadding = screenWidth / 16

let arrowUpImage = #imageLiteral(resourceName: "ArrowUp")
let arrowDownImage = #imageLiteral(resourceName: "ArrowDown")

let editImage = #imageLiteral(resourceName: "Edit")

var isPhone: Bool { UIDevice.current.userInterfaceIdiom == .phone }
