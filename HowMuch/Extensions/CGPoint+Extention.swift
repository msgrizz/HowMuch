//
//  CGPoint+Extention.swift
//  HowMuch
//
//  Created by Максим Казаков on 12/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import UIKit

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        let xDist = x - point.x
        let yDist = y - point.y
        return CGFloat(sqrt((xDist * xDist) + (yDist * yDist)))
    }
}


// MARK: - Image Scaling.
extension UIImage {
    
    /// Represents a scaling mode
    enum ScalingMode {
        case aspectFill
        case aspectFit
        
        /// Calculates the aspect ratio between two sizes
        ///
        /// - parameters:
        ///     - size:      the first size used to calculate the ratio
        ///     - otherSize: the second size used to calculate the ratio
        ///
        /// - return: the aspect ratio between the two sizes
        func aspectRatio(between size: CGSize, and otherSize: CGSize) -> CGFloat {
            let aspectWidth  = size.width/otherSize.width
            let aspectHeight = size.height/otherSize.height
            
            switch self {
            case .aspectFill:
                return max(aspectWidth, aspectHeight)
            case .aspectFit:
                return min(aspectWidth, aspectHeight)
            }
        }
    }
    
    /// Scales an image to fit within a bounds with a size governed by the passed size. Also keeps the aspect ratio.
    ///
    /// - parameter:
    ///     - newSize:     the size of the bounds the image must fit within.
    ///     - scalingMode: the desired scaling mode
    ///
    /// - returns: a new scaled image.
    func scaled(to newSize: CGSize, scalingMode: UIImage.ScalingMode = .aspectFill) -> (CGRect, UIImage) {
        
        let aspectRatio = scalingMode.aspectRatio(between: newSize, and: size)
        
        /* Build the rectangle representing the area to be drawn */
        var scaledImageRect = CGRect.zero
        
        scaledImageRect.size.width  = size.width * aspectRatio
        scaledImageRect.size.height = size.height * aspectRatio
        scaledImageRect.origin.x    = (newSize.width - size.width * aspectRatio) / 2.0
        scaledImageRect.origin.y    = (newSize.height - size.height * aspectRatio) / 2.0
        
        /* Draw and retrieve the scaled image */
        UIGraphicsBeginImageContext(newSize)
        
        draw(in: scaledImageRect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return (scaledImageRect, scaledImage!)
    }
    
    
    func scaled(to rect: CGRect, scalingMode: UIImage.ScalingMode = .aspectFill) -> UIImage {
        UIGraphicsBeginImageContext(rect.size)
        
        draw(in: rect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
    
    
    
    
    
    
    static func rect(from oldSize: CGSize, to newSize: CGSize, scalingMode: UIImage.ScalingMode = .aspectFill) -> CGRect {
        let aspectRatio = scalingMode.aspectRatio(between: newSize, and: oldSize)
        var scaledImageRect = CGRect.zero
        
        scaledImageRect.size.width  = oldSize.width * aspectRatio
        scaledImageRect.size.height = oldSize.height * aspectRatio
        scaledImageRect.origin.x    = (newSize.width - oldSize.width * aspectRatio) / 2.0
        scaledImageRect.origin.y    = (newSize.height - oldSize.height * aspectRatio) / 2.0
        
        return scaledImageRect
    }
}
