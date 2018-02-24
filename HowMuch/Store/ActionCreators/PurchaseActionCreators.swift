//
//  PurchaseActionCreators.swift
//  HowMuch
//
//  Created by Максим Казаков on 24/02/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import StoreKit
import ReSwift


func ActualizePurchasesAction(state: AppState) -> SetPurchasesAction {
    let actualInfos = removedExpired(purchases: state.purchaseState.purchasedProducts)
    if actualInfos.count == 0 {
        DispatchQueue.main.async {
            store.dispatch(SetResultCurrencyAction(currency: .USD))
        }
    }
    return SetPurchasesAction(purchaseInfos: actualInfos)
}



func LoadLocalPurchasesAction(state: AppState) -> SetPurchasesAction {
    let purchaseInfos = Products.allIdentifiers.flatMap { id in
        return PurchaseHelper.shared.loadPurchase(identifier: id).map{ date in PurchaseInfo(identifier: id, date: date) }
    }
    DispatchQueue.main.async {
        store.dispatch(ActualizePurchasesAction(state: store.state))
    }
    return SetPurchasesAction(purchaseInfos: purchaseInfos)
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
