//
//  Products.swift
//  HowMuch
//
//  Created by Максим Казаков on 21/02/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import Foundation


public struct Products {
    
    static let shared = Products()
    
    static let forever: ProductIdentifier = "com.maxkazakov.Howmuch.AllCurrenciesNoAds"
    static let subscribes: Set<ProductIdentifier> = ["com.maxkazakov.Howmuch.AllCurrenciesNoAds1Week",
                                                    "com.maxkazakov.Howmuch.AllCurrenciesNoAds1Month"]
    static let all = Set<ProductIdentifier>([forever]).union(subscribes)    
    static let store = PurchaseHelper(productIds: all)
}
