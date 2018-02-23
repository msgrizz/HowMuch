//
//  Products.swift
//  HowMuch
//
//  Created by Максим Казаков on 21/02/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import Foundation


enum ProductType: Equatable {
    case forever
    case subscription(term: Int)
    
    static func ==(lhs: ProductType, rhs: ProductType) -> Bool {
        switch (lhs, rhs) {
        case (.forever, .forever):
            return true
//        case (.subscription(let term1), .subscription(let term2)):
//            return term1 == term2
        case (.subscription, .subscription):
            return true
        default:
            return false
        }
    }
}

struct ProductInfo {
    let identifier: ProductIdentifier
    let type: ProductType
}

public struct Products {
    static let all = [
        ProductInfo(identifier: "com.maxkazakov.Howmuch.AllCurrenciesNoAds", type: .forever),
        ProductInfo(identifier: "com.maxkazakov.Howmuch.AllCurrenciesNoAds1Week", type: .subscription(term: 7)),
        ProductInfo(identifier: "com.maxkazakov.Howmuch.AllCurrenciesNoAds1Month", type: .subscription(term: 31)),
    ]
    
    static func getInfoBy(identifier: ProductIdentifier) -> ProductInfo? {
        return all.first { $0.identifier == identifier }
    }
    
    static var allIdentifiers = Set(all.map { $0.identifier })
}
