//
//  Fonts.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 02/10/2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

let montserratRegular = "Montserrat-Regular"
let montserratMedium = "Montserrat-Medium"
let montserratSemiBold = "Montserrat-SemiBold"

extension UIFont {
    
    static var device: UIUserInterfaceIdiom {
        return UIDevice.current.userInterfaceIdiom
    }
    static var goalTitleFontSize: CGFloat {
        return device == .phone ? 18 : 20
    }
    static var goalDescriptionFontSize: CGFloat {
        return device == .phone ? 12 : 14
    }
    static var triggerFontSize: CGFloat {
        return device == .phone ? 14 : 16
    }
    static var habitFontSize: CGFloat {
        return device == .phone ? 14 : 16
    }
    static var statisticsNumberFontSize: CGFloat {
        return device == .phone ? 18 : 20
    }
    static var statisticsTextFontSize: CGFloat {
        return device == .phone ? 10 : 12
    }
    static var headerFontSize: CGFloat {
        return device == .phone ? 20 : 22
    }
    static var filterFontSize: CGFloat {
        return device == .phone ? 12 : 14
    }
    static var segmentedControlFontSize: CGFloat {
        return device == .phone ? 12 : 14
    }
    static var graphNumbersFontSize: CGFloat {
        return device == .phone ? 8 : 10
    }
    static var graphSignaturesFontSize: CGFloat {
        return device == .phone ? 10 : 12
    }

    static let goalTitleFont = UIFont(name: montserratSemiBold, size: UIFont.goalTitleFontSize)
    static let goalDescriptionFont = UIFont(name: montserratRegular, size: UIFont.goalDescriptionFontSize)
    
    static let triggerFont = UIFont(name: montserratMedium, size: UIFont.triggerFontSize)
    static let habitFont = UIFont(name: montserratRegular, size: UIFont.habitFontSize)
    
    static let noteFont = UIFont(name: montserratSemiBold, size: UIFont.habitFontSize)
    
    static let statisticsNumberFont = UIFont(name: montserratSemiBold, size: UIFont.statisticsNumberFontSize)
    static let statisticsTextFont = UIFont(name: montserratRegular, size: UIFont.statisticsTextFontSize)
    
    static let graphSignaturesFont = UIFont(name: montserratRegular, size: graphSignaturesFontSize)
    
    static let selectedSegmControlFont = UIFont(name: montserratSemiBold, size: segmentedControlFontSize)
    static let deselectedSegmControlFont = UIFont(name: montserratMedium, size: segmentedControlFontSize)
    
    static let headerFont = UIFont(name: montserratSemiBold, size: UIFont.headerFontSize)
}
