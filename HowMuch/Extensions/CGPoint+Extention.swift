//
//  CGPoint+Extention.swift
//  HowMuch
//
//  Created by Максим Казаков on 12/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import CoreGraphics

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        let xDist = x - point.x
        let yDist = y - point.y
        return CGFloat(sqrt((xDist * xDist) + (yDist * yDist)))
    }
}
