//
//  PurchaseHelper.swift
//  HowMuch
//
//  Created by Максим Казаков on 21/02/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import Foundation
import StoreKit

public typealias ProductIdentifier = String
public typealias ProductsRequestCompletionHandler = (_ error: Error?, _ products: [SKProduct]) -> ()


class PurchaseHelper: NSObject {
    static let shared = PurchaseHelper()
    
    fileprivate var productsRequest: SKProductsRequest?
    fileprivate var productsRequestCompletionHandler: ProductsRequestCompletionHandler?
    
    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    
    public func requestProducts(productIdentifiers: Set<ProductIdentifier>, completionHandler: @escaping ProductsRequestCompletionHandler) {
        productsRequest?.cancel()
        productsRequestCompletionHandler = completionHandler
        
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest!.delegate = self
        productsRequest!.start()
    }
    
    
    public func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    
    
    public func buyProduct(_ product: SKProduct) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    
    
    func clearRequestAndHandler() {
        productsRequest = nil
        productsRequestCompletionHandler = nil
    }
    
    
    
    func loadPurchase(identifier: ProductIdentifier) -> Date? {
        return UserDefaults.standard.object(forKey: identifier) as? Date
    }
    
    
    func savePurchase(info: PurchaseInfo) {
        UserDefaults.standard.set(info.date, forKey: info.identifier)
    }
}

// MARK: - SKPaymentTransactionObserver
extension PurchaseHelper: SKPaymentTransactionObserver {
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch (transaction.transactionState) {
            case .purchased:
                complete(transaction: transaction)
                break
            case .failed:
                fail(transaction: transaction)
                break
            case .restored:
                restore(transaction: transaction)
                break
            case .deferred:
                break
            case .purchasing:
                break
            }
        }
    }
    
    
    private func complete(transaction: SKPaymentTransaction) {
        deliverPurchaseNotificationFor(identifier: transaction.payment.productIdentifier, date: transaction.transactionDate)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    
    
    private func restore(transaction: SKPaymentTransaction) {
        guard let originalTransaction = transaction.original else { return }
        deliverPurchaseNotificationFor(identifier: originalTransaction.payment.productIdentifier, date: originalTransaction.transactionDate)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    
    
    private func fail(transaction: SKPaymentTransaction) {
        print(transaction.error ?? "")
        store.dispatch(FailurePaymentAction())
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    
    
    private func deliverPurchaseNotificationFor(identifier: String?, date: Date?) {
        guard let identifier = identifier, let date = date else { return }
        let purchaseInfo = PurchaseInfo(identifier: identifier, date: date)
        store.dispatch(SuccessPaymentAction(purchaseInfo: purchaseInfo))
    }
}




extension PurchaseHelper: SKProductsRequestDelegate {
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let products = response.products
        productsRequestCompletionHandler?(nil, products)
        clearRequestAndHandler()
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        productsRequestCompletionHandler?(error, [])
        clearRequestAndHandler()
    }
}
