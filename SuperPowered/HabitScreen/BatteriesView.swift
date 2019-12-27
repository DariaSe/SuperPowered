//
//  BatteriesView.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 07.12.2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

class BatteriesView: UIView {
    
    // MARK: - Properties
    
    var progress: Int? {
        didSet {
            if previousProgress == nil || previousProgress == self.progress {
                guard let progress = progress else { return }
                redBattery.progress = progress
                greenBattery.progress = progress
            }
            else {
                guard let isIncreasing = isIncreasing else { return }
                if isIncreasing {
                    activateGreen()
                }
                else {
                    activateRed()
                }
            }
            previousProgress = self.progress
        }
    }
    
    var previousProgress: Int?
    
    var isIncreasing: Bool? {
        guard let previousProgress = previousProgress, let progress = progress else { return nil }
        if previousProgress == progress { return nil }
        if previousProgress < progress { return true }
        else { return false }
        
    }
    
    var lastCheckInType: HabitType? {
        didSet {
            colorChargers()
        }
    }
    
    func restart() {
        previousProgress = nil
        progress = 0
        previousProgress = nil
        lastCheckInType = nil
        redBattery.stopEmitting()
        greenBattery.stopEmitting()
        topRedCharger.isColored = false
        bottomRedCharger.isColored = false
        topGreenCharger.isColored = false
        bottomGreenCharger.isColored = false
    }
    // MARK: - Outlets
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var redContainer: UIView!
    @IBOutlet weak var greenContainer: UIView!
    
    @IBOutlet weak var redBattery: BatteryEffectsView!
    @IBOutlet weak var greenBattery: BatteryEffectsView!
    
    @IBOutlet weak var topRedCharger: ChargerView!
    @IBOutlet weak var bottomRedCharger: ChargerView!
    
    @IBOutlet weak var topGreenCharger: ChargerView!
    @IBOutlet weak var bottomGreenCharger: ChargerView!
    
    // MARK: - Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    func commonInit() {
        Bundle.main.loadNibNamed("BatteriesView", owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
    
        setupUI()
    }
    
    func setupUI() {
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        redContainer.backgroundColor = .clear
        redContainer.transform = CGAffineTransform(rotationAngle: .pi / 2)
        greenContainer.backgroundColor = .clear
        greenContainer.transform = CGAffineTransform(rotationAngle: .pi / 2)
        
        redBattery.isRed = true
        greenBattery.isRed = false
        
        setupChargers()
    }
    
    func setupChargers() {
        topRedCharger.isRed = true
        topGreenCharger.isRed = false
        
        bottomRedCharger.isRed = true
        bottomGreenCharger.isRed = false
        
        bottomRedCharger.transform = CGAffineTransform(rotationAngle: .pi)
        bottomGreenCharger.transform = CGAffineTransform(rotationAngle: .pi)
    }
    
    func colorChargers() {
        if let lastCheckInType = lastCheckInType {
            if lastCheckInType == .bad {
                topRedCharger.isColored = true
                bottomRedCharger.isColored = true
            }
            else {
                topGreenCharger.isColored = true
                bottomGreenCharger.isColored = true
            }
        }
    }
    
    func deactivateChargers() {
        greenBattery.stopEmitting()
        redBattery.stopEmitting()
        if topRedCharger.isColored {
            topRedCharger.animateColorChange()
            topGreenCharger.animateColorChange()
        }
        if bottomRedCharger.isColored {
            bottomRedCharger.animateColorChange()
            bottomGreenCharger.animateColorChange()
        }
        
    }
    func activateRed() {
        print("activate red gets called")
        greenBattery.stopEmitting()
        if !topRedCharger.isColored {
            topRedCharger.animateColorChange()
            topGreenCharger.animateColorChange()
        }
        topRedCharger.emit()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.topRedCharger.stopEmitting()
        }
        if !bottomRedCharger.isColored {
            bottomRedCharger.animateColorChange()
            bottomGreenCharger.animateColorChange()
        }
        bottomRedCharger.emit()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.bottomRedCharger.stopEmitting()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.redBattery.animateFrame()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.redBattery.progress = self.progress!
            self.greenBattery.progress = self.progress!
            self.redBattery.emit()
        }
    }
    
    func activateGreen() {
        redBattery.stopEmitting()
        if !topGreenCharger.isColored {
            topGreenCharger.animateColorChange()
            topRedCharger.animateColorChange()
        }
        topGreenCharger.emit()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.topGreenCharger.stopEmitting()
        }
        if !bottomGreenCharger.isColored {
            bottomGreenCharger.animateColorChange()
            bottomRedCharger.animateColorChange()
        }
        bottomGreenCharger.emit()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.bottomGreenCharger.stopEmitting()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.greenBattery.animateFrame()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.greenBattery.progress = self.progress!
            self.redBattery.progress = self.progress!
            self.greenBattery.emit()
            
        }
    }
}
