//
//  CircleView.swift
//  Task5
//
//  Created by neoviso on 9/2/22.
//

import UIKit

class CircleView: UIView {

    let circleBorder: CGFloat = 3.0

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        let circleSize = frame.size.width - circleBorder;
        let circleRect = CGRect(x: circleBorder / 2,
                                y: circleBorder / 2,
                                width: circleSize,
                                height: circleSize)

        let circlePath = UIBezierPath(ovalIn: circleRect)
        circlePath.lineWidth = circleBorder

        UIColor.random.setStroke()
        circlePath.stroke()
        
        UIColor.random.setFill()
        circlePath.fill()
    }
}

extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random(in: 0...1),
                     green: .random(in: 0...1),
                     blue: .random(in: 0...1), alpha: 1.0)
    }
}


