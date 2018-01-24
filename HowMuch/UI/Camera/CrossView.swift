//
//  CrossView.swift
//  HowMuch
//
//  Created by Максим Казаков on 24/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import UIKit

class CrossView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func draw(_ rect: CGRect) {
        let center = rect.center
        let startX = center.x - 10
        let startY = center.y - 10
        let path = UIBezierPath()
        path.move(to: CGPoint(x: startX, y: startY + 10))
        path.addLine(to: CGPoint(x: startX + 20, y: startY + 10))
        path.move(to: CGPoint(x: startX + 10, y: startY))
        path.addLine(to: CGPoint(x: startX + 10, y: startY + 20))
        
        UIColor.red.setStroke()
        path.stroke()
    }
}
