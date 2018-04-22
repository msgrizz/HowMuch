//
//  CGRect+Extention.swift
//  HowMuch
//
//  Created by Максим Казаков on 12/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import CoreGraphics


extension CGRect {
    var center: CGPoint {
        return CGPoint(x: minX + width / 2, y: minY + height / 2)
    }
}


extension CGSize {
    var center: CGPoint {
        return CGPoint(x: width / 2, y: height / 2)
    }
}
