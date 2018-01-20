//
//  RegionRects.swift
//  HowMuch
//
//  Created by Максим Казаков on 20/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import UIKit

struct RegionRects {
    /// Прямоугольник всего слова
    let wordRect: CGRect
    /// Прямоугольники посимвольно
    let charRects: [CGRect]
    /// Прямоугольник с целой частью
    let ceilRect: CGRect
    /// Прямоугольник с дробной частью
    let floorRect: CGRect
    /// Прямоугольник с разделителем
    let delimiterRect: CGRect
    /// Количество знаков в целой части
    let ceilCount: Int
    /// Количество знаков в дробной части
    let floorCount: Int
}

