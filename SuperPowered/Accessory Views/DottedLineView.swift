//
//  DottedLineView.swift
//  Triggio
//
//  Created by Дарья Селезнёва on 07/07/2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

enum Direction {
    case vertical
    case horizontal
    case diagonal
}

class DottedLineView: UIView {
    
    var lineWidth: CGFloat = 1
    var color: UIColor = UIColor.dottedLineColor {
        didSet {
            setNeedsDisplay()
        }
    }
    var direction: Direction = .vertical
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        var startPoint = CGPoint(x: 0, y: 0)
        var endPoint = CGPoint(x: 0, y: 0)
        switch direction {
        case .vertical:
            startPoint = CGPoint(x: rect.midX, y: 0)
            endPoint = CGPoint(x: rect.midX, y: rect.maxY)
        case .horizontal:
            startPoint = CGPoint(x: 0, y: rect.midY)
            endPoint = CGPoint(x: rect.maxX, y: rect.midY)
        default:
            startPoint = CGPoint(x: 2, y: rect.maxY - 2)
            endPoint = CGPoint(x: rect.maxX - 2, y: 2)
        }
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        path.lineWidth = lineWidth
        path.setLineDash([lineWidth, lineWidth * 2], count: 2, phase: 0.0)
        color.setStroke()
        path.stroke()
        }
}
