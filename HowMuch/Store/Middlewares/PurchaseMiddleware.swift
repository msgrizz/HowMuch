//
//  PurchaseMiddleware.swift
//  HowMuch
//
//  Created by Максим Казаков on 23/02/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import ReSwift

let ProductsLoadingMiddleware: Middleware<AppState> = { dispatch, state in
    return { next in
        return { action in
            if action is LoadProductsAction {
                PurchaseHelper.shared.requestProducts(productIdentifiers: Products.allIdentifiers) { error, products in
                    if let error = error {
                        dispatch(FailureLoadedProductsAction(error: error.localizedDescription))
                    } else {
                        dispatch(SuccessLoadedProductsAction(products: products))
                    }
                }
//                for prod in products {
//                    print("Found product: \(prod.productIdentifier) \(prod.localizedTitle) \(prod.price.floatValue)")
//                }
            }
            return next(action)
        }
    }
}


let PurchaseMiddleware: Middleware<AppState> = { dispatch, state in
    return { next in
        return { action in
            switch action {
            case let buyAction as BuyProductAction:
                PurchaseHelper.shared.buyProduct(buyAction.product)
            case let restoreAction as RestorePurchasesAction:
                PurchaseHelper.shared.restorePurchases()
            case let successAction as SuccessPaymentAction:
                PurchaseHelper.shared.savePurchase(info: successAction.purchaseInfo)            
            default:
                break
            }
            return next(action)
        }
    }
}
