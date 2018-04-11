//
//  CrossView.swift
//  HowMuch
//
//  Created by Максим Казаков on 24/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import UIKit

class CrossView: UIView {
    
    static let height = CGFloat(100)
    static let width = CGFloat(180)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func draw(_ rect: CGRect) {
        let center = rect.center
        
        let centerX = center.x
        let centerY = center.y
        let path = UIBezierPath()
        
        let baselength = CGFloat(20)
        let halfBaseLength = baselength / 2
        let height = CrossView.height / 2
        let width = CrossView.width / 2
        
        let startX = centerX - halfBaseLength
        let startY = centerY - halfBaseLength
        
        path.move(to: CGPoint(x: startX, y: startY + halfBaseLength))
        path.addLine(to: CGPoint(x: startX + baselength, y: startY + halfBaseLength))
        path.move(to: CGPoint(x: startX + halfBaseLength, y: startY))
        path.addLine(to: CGPoint(x: startX + halfBaseLength, y: startY + baselength))
        
        path.move(to: CGPoint(x: centerX - width, y: centerY - height + baselength))
        path.addLine(to: CGPoint(x: centerX - width, y: centerY - height))
        path.addLine(to: CGPoint(x: centerX - width + baselength, y: centerY - height))
        
        path.move(to: CGPoint(x: centerX + width, y: centerY + height - baselength))
        path.addLine(to: CGPoint(x: centerX + width, y: centerY + height))
        path.addLine(to: CGPoint(x: centerX + width - baselength, y: centerY + height))
        
        path.move(to: CGPoint(x: centerX + width, y: centerY - height + baselength))
        path.addLine(to: CGPoint(x: centerX + width, y: centerY - height))
        path.addLine(to: CGPoint(x: centerX + width - baselength, y: centerY - height))
        CrossView.crossColor.setStroke()
        
        path.move(to: CGPoint(x: centerX - width, y: centerY + height - baselength))
        path.addLine(to: CGPoint(x: centerX - width, y: centerY + height))
        path.addLine(to: CGPoint(x: centerX - width + baselength, y: centerY + height))
        
        path.lineWidth = 2
        path.stroke()
    }
    
    
    private static let crossColor: UIColor = #colorLiteral(red: 1, green: 0.1411764706, blue: 0.3568627451, alpha: 1)
}
