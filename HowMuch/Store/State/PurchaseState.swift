//
//  PurchaseState.swift
//  HowMuch
//
//  Created by Максим Казаков on 23/02/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import ReSwift
import StoreKit

enum ProductState: Equatable {
    
    case notBought
    case disabled
    case inProcess
    case bought(date: Date)
    
    static func ==(lhs: ProductState, rhs: ProductState) -> Bool {
        switch (lhs, rhs) {
        case (.notBought, .notBought):
            return true
        case (.disabled, .disabled):
            return true
        case (.inProcess, .inProcess):
            return true
        case (.bought, .bought):
            return true
        default:
            return false
        }
    }
}



struct PurchaseInfo: Equatable {
    let identifier: ProductIdentifier
    let date: Date
    
    static func ==(lhs: PurchaseInfo, rhs: PurchaseInfo) -> Bool {
        return lhs.identifier == rhs.identifier
            && lhs.date == rhs.date
    }
}



struct PurchaseState: StateType, Equatable {
    var isPurchased: Bool
    var isLoading: Bool
    var products: [SKProduct]
    var productInProcess: SKProduct?
    var purchasedProducts = [PurchaseInfo]()
    
    static let `default` = PurchaseState(isPurchased: false, isLoading: false, products: [], productInProcess: nil, purchasedProducts: [])
    
    static func ==(lhs: PurchaseState, rhs: PurchaseState) -> Bool {
        return lhs.purchasedProducts == rhs.purchasedProducts
            && lhs.products == rhs.products
            && lhs.isLoading == rhs.isLoading
            && lhs.productInProcess == rhs.productInProcess
            && lhs.isPurchased == rhs.isPurchased
    }
}
