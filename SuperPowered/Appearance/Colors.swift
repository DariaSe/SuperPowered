//
//  Colors.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 02/10/2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

extension UIColor {
    static var backgroundColor: UIColor {
        return UIColor(netHex: 0x272727)
    }
    static var backgroundCompanionColor: UIColor {
        return UIColor(netHex: 0x2F2F2F)
    }
    static var barBackgroundColor: UIColor {
        return UIColor(netHex: 0x121212)
    }
    static var goalTextColor: UIColor {
        return UIColor(netHex: 0x272727)
    }
    static var textColor: UIColor {
        return UIColor(netHex: 0xC4C3B6)
    }
    static var placeholderTextColor: UIColor {
        return UIColor(netHex: 0x555555)
    }
    static var goalPlaceholderTextColor: UIColor {
        return UIColor(netHex: 0x555555).withAlphaComponent(0.4)
    }
    static var linesColor: UIColor {
        return UIColor(netHex: 0x3E3E3E)
    }
    static var dottedLineColor: UIColor {
        return UIColor(netHex: 0xADACA0)
    }
    static var shadowColor: UIColor {
        return UIColor.black
    }
    static var habitViewsPlaceholderColor: UIColor {
        return UIColor(netHex: 0x2F2F2F)
    }
    struct AppColors {
        static let backgroundColor = UIColor(netHex: 0x272727)
        //textfields, buttons
        static let backgroundCompanionColor = UIColor(netHex: 0x2F2F2F)
        static let navigationBarBackgroundColor = UIColor(netHex: 0x121212)
        static let achievementCircleGrey = UIColor(netHex: 0x3E3E3E)
        static let textColorLightGrey = UIColor(netHex: 0xC4C3B6)
        static let placeholderTextColor = UIColor(netHex: 0x555555)
        
        static let red = UIColor(netHex: 0xCE455F)
        static let textRed = UIColor(netHex: 0x9A4746)
        static let green = UIColor(netHex: 0x2DBEAD)
        static let lightGreen = UIColor(netHex: 0x7DAA61)
        static let darkGreen = UIColor(netHex: 0x46871E)
        static let turquoise = UIColor(netHex: 0x119D92)
        static let darkTurquoise = UIColor(netHex: 0x1F4946)
        static let blue = UIColor(netHex: 0x4BB3D3)
        static let darkBlue = UIColor(netHex: 0x30505A)
        
        static let lightBrown = UIColor(netHex: 0x8B6207)
        static let darkBrown = UIColor(netHex: 0x674906)
        
        static let lineBlue = UIColor(netHex: 0x8AABAF)
        
        static let secondGreen = UIColor(netHex: 0xA3D24F)
        static let thirdGreen = UIColor(netHex: 0xCDD24F)
    }
    struct GoalColors {
        //1
        static let orange = UIColor(netHex: 0xEDA637)
        //2
        static let lachs = UIColor(netHex: 0xFECEA8)
        //3
        static let lightPink = UIColor(netHex: 0xF9E6E6)
        //4
        static let makeup = UIColor(netHex: 0xF2E1C7)
        //5
        static let lightYellow = UIColor(netHex: 0xF4F3BB)
        //6
        static let yellow = UIColor(netHex: 0xF5F583)
        //7
        static let hucky = UIColor(netHex: 0xB1BF61)
        //8
        static let lightGreen = UIColor(netHex: 0xA3D24F)
        //9
        static let green = UIColor(netHex: 0x74C770)
        //10
        static let mint = UIColor(netHex: 0xA8E6CE)
        //11
        static let turquoise = UIColor(netHex: 0x66C8D0)
        //12
        static let lightBlue = UIColor(netHex: 0x69C8FF)
        //13
        static let blue = UIColor(netHex: 0x4DA5F0)
        //14
        static let pink = UIColor(netHex: 0xE3B7E5)
        //15
        static let purple = UIColor(netHex: 0xB3ACD8)
        //16
        static let lightPurple = UIColor(netHex: 0xDDDBDC)
        //17
        static let lightGrayBlue = UIColor(netHex: 0xCFE0DF)
        //18
        static let gray = UIColor(netHex: 0xC3C2BE)
        //19
        static let brown = UIColor(netHex: 0xA57710)
        //20
        static let white = UIColor(netHex: 0xFFFFFF)
    }
    
}
var goalColors: [UIColor] = [UIColor.GoalColors.orange, UIColor.GoalColors.lachs, UIColor.GoalColors.lightPink, UIColor.GoalColors.makeup, UIColor.GoalColors.lightYellow, UIColor.GoalColors.yellow, UIColor.GoalColors.hucky, UIColor.GoalColors.lightGreen, UIColor.GoalColors.green, UIColor.GoalColors.mint, UIColor.GoalColors.turquoise, UIColor.GoalColors.lightBlue, UIColor.GoalColors.blue, UIColor.GoalColors.pink, UIColor.GoalColors.purple, UIColor.GoalColors.lightPurple, UIColor.GoalColors.lightGrayBlue, UIColor.GoalColors.gray, UIColor.GoalColors.brown, UIColor.GoalColors.white]

extension UIColor {
    static func goalColor(index: Int) -> UIColor {
        return goalColors[index]
    }
}
