//
//  StoreReviewHelper.swift
//  HowMuch
//
//  Created by Максим Казаков on 20/02/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import StoreKit

class StoreReviewHelper {
    
    static let OpenedCounterKey = "OpenedCounterKey"
    
    static func isFirstStart() -> Bool {
        return UserDefaults.standard.value(forKey: OpenedCounterKey) == nil
    }
    
    
    static func incrementAppOpenedCounter() {
        let defaults = UserDefaults.standard        
        guard var appOpenCount = defaults.value(forKey: OpenedCounterKey) as? Int else {
            defaults.set(1, forKey: OpenedCounterKey)
            return
        }
        appOpenCount += 1
        defaults.set(appOpenCount, forKey: OpenedCounterKey)
    }
    
    
    static func checkAndAskForReview() {
        let defaults = UserDefaults.standard
        guard let appOpenCount = defaults.value(forKey: OpenedCounterKey) as? Int else {
            defaults.set(1, forKey: OpenedCounterKey)
            return
        }
        if appOpenCount == 3 || appOpenCount == 10 || appOpenCount % 50 == 0 {
            SKStoreReviewController.requestReview()
        }
    }
}
