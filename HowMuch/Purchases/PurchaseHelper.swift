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
public typealias ProductsRequestCompletionHandler = (_ success: Bool, _ products: [SKProduct]?) -> ()


class PurchaseHelper: NSObject {
    fileprivate let productIdentifiers: Set<ProductIdentifier>
    public var purchasedProducts = Set<ProductIdentifier>()
    
    fileprivate var productsRequest: SKProductsRequest?
    fileprivate var productsRequestCompletionHandler: ProductsRequestCompletionHandler?
    
    init(productIds: Set<ProductIdentifier>) {
        productIdentifiers = productIds
        purchasedProducts = Set(productIds.filter { UserDefaults.standard.bool(forKey: $0) })
        
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    
    public func requestProducts(completionHandler: @escaping ProductsRequestCompletionHandler) {
        productsRequest?.cancel()
        productsRequestCompletionHandler = completionHandler
        
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest!.delegate = self
        productsRequest!.start()
    }
    
    
    
    func clearRequestAndHandler() {
        productsRequest = nil
        productsRequestCompletionHandler = nil
    }
}


extension PurchaseHelper: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
    }
}


extension PurchaseHelper: SKProductsRequestDelegate {
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let products = response.products
        print("Loaded list of products...")
        productsRequestCompletionHandler?(true, products)
        clearRequestAndHandler()
        for prod in products {
            print("Found product: \(prod.productIdentifier) \(prod.localizedTitle) \(prod.price.floatValue)")
        }
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Failed to load list of products.")
        print("Error: \(error.localizedDescription)")
        productsRequestCompletionHandler?(false, nil)
        clearRequestAndHandler()
    }
}
