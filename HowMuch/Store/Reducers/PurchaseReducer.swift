//
//  PurchasesReducer.swift
//  HowMuch
//
//  Created by Максим Казаков on 23/02/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import ReSwift

func PurchaseReducer(action: Action, state: PurchaseState?) -> PurchaseState {
    var state = state ?? initState()
    
    switch action {
    case is LoadProductsAction:
        state.isLoading = true
        
    case let successLoaded as SuccessLoadedProductsAction:
        state.isLoading = false
        state.products = successLoaded.products
        
    case is FailureLoadedProductsAction:
        state.isLoading = false
        
    case let successPayment as SuccessPaymentAction:
        state.purchasedProducts.append(successPayment.purchaseInfo)
        state.productInProcess = nil
        state.isPurchased = true
        
    case let buyProduct as BuyProductAction:
        state.productInProcess = buyProduct.product
        
    case is FailurePaymentAction:
        state.productInProcess = nil
        
    case let action as LoadPurchasedAction:
        let actualPurchases = removedExpired(purchases: action.purchaseInfos)
        state.isPurchased = actualPurchases.count > 0
        state.purchasedProducts = actualPurchases
    
    case is CheckExpiredPurchasesAction:
        let actualPurchases = removedExpired(purchases: state.purchasedProducts)
        state.isPurchased = actualPurchases.count > 0
        state.purchasedProducts = actualPurchases
    default:
        break
    }
    return state
}


/// Отфильтровывает устаревшие покупки, возвращает акутальные
fileprivate func removedExpired(purchases: [PurchaseInfo]) -> [PurchaseInfo] {
    return purchases.flatMap { purchase in
        let product = Products.getInfoBy(identifier: purchase.identifier)!
        switch product.type {
        case .forever:
            return purchase
        case .subscription(let term):
            let dayDiff = Calendar.current.dateComponents([.day], from: purchase.date, to: Date()).day ?? 0
            if dayDiff > term {
                PurchaseHelper.shared.removePurchase(identifier: purchase.identifier)
                return nil
            }
            return purchase
        }
    }
}


fileprivate func initState() -> PurchaseState {
    return PurchaseState.default
}
