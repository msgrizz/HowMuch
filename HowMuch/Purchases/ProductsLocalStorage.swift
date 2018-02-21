//
//  ProductsLocalStorage.swift
//  HowMuch
//
//  Created by Максим Казаков on 21/02/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import Foundation


class ProductsLocalStorage {
    static let shared = ProductsLocalStorage()
    
    
    public var forever: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: ProductsLocalStorage.foreverKey)
        }
        get {
            return UserDefaults.standard.bool(forKey: ProductsLocalStorage.foreverKey)
        }
    }
    
    
    public var subscriptionOneWeek: Date? {
        set {
            UserDefaults.standard.set(newValue, forKey: ProductsLocalStorage.subscriptionOneWeekKey)
        }
        get {
            return UserDefaults.standard.object(forKey: ProductsLocalStorage.subscriptionOneWeekKey) as? Date
        }
    }
    
    
    public var subscriptionOneMonth: Date? {
        set {
            UserDefaults.standard.set(newValue, forKey: ProductsLocalStorage.subscriptionOneMonthKey)
        }
        get {
            return UserDefaults.standard.object(forKey: ProductsLocalStorage.subscriptionOneMonthKey) as? Date
        }
    }
    
    // MARK: -Private
    private static let foreverKey = "forever"
    private static let subscriptionOneWeekKey = "subscriptionOneWeek"
    private static let subscriptionOneMonthKey = "subscriptionOneMonth"
    
    private init() {}
}

