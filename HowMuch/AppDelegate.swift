//
//  AppDelegate.swift
//  Text Detection Starter Project
//
//  Created by Sai Kambampati on 6/21/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import ReSwift
import StoreKit
import GoogleMobileAds

var store = Store<AppState>(
    reducer: AppReducer,
    state: nil,
    middleware: [LoggingMiddleware, LoadCurrencyRatesMiddleware,
                 UpdateCurrencyRatesMiddleware, LoadSettingsMiddleware,
                 SaveSettingsMiddleware, ProductsLoadingMiddleware,
                 PurchaseMiddleware])





@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        // На случай ввода промокода
        let _ = PurchaseHelper.shared        
        
        window.tintColor = Colors.accent1
        let appearance = UINavigationBar.appearance()
        appearance.tintColor = Colors.accent1
        
        let rootVc = RecognizerViewController()
        let initialViewController = UINavigationController(rootViewController: rootVc)
        initialViewController.navigationBar.prefersLargeTitles = true
        window.rootViewController = initialViewController
        window.makeKeyAndVisible()
        
        store.dispatch(TryUpdateCurrencyRateAction())
        store.dispatch(LoadLocalPurchasesAction(state: store.state))
                
        GADMobileAds.configure(withApplicationID: AdMob.adMobId)

        if StoreReviewHelper.isFirstStart() {
            if let currencyCode = (Locale.current as NSLocale).object(forKey: .currencyCode) as? String,
                let currency = Currency(rawValue: currencyCode) {
                    store.dispatch(SetResultCurrencyAction(currency: currency))
            }
        }
        StoreReviewHelper.incrementAppOpenedCounter()
        
        self.window = window

        return true
    }
    
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        store.dispatch(TryUpdateCurrencyRateAction())
        store.dispatch(ActualizePurchasesAction(state: store.state))        
        
        StoreReviewHelper.incrementAppOpenedCounter()
        StoreReviewHelper.checkAndAskForReview()
    }
}

