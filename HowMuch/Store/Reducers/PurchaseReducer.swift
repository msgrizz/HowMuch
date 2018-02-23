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
        
    case let failureLoaded as FailureLoadedProductsAction:
        state.isLoading = false
        
    case let successPayment as SuccessPaymentAction:
        state.purchasedProducts.append(successPayment.purchaseInfo)
        state.productInProcess = nil
        
    case let buyProduct as BuyProductAction:
        state.productInProcess = buyProduct.product
        
    case is FailurePaymentAction:
        state.productInProcess = nil
        
    case let action as LoadPurchasedAction:
        state.purchasedProducts += action.purchaseInfos

    default:
        break
    }
    return state
}



func initState() -> PurchaseState {
    return PurchaseState.default
}
