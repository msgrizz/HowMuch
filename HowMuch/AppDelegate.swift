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
        
        window.tintColor = Colors.accent1
        let appearance = UINavigationBar.appearance()
//        appearance.isTranslucent = false
//        appearance.barTintColor = Colors.accent2
        appearance.tintColor = Colors.accent1
//        let textAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
//        appearance.titleTextAttributes = textAttributes
        
        let pictureListVc = RecognizerViewController()
        let initialViewController = UINavigationController(rootViewController: pictureListVc)
        initialViewController.navigationBar.prefersLargeTitles = true
        window.rootViewController = initialViewController
        window.makeKeyAndVisible()
        
        store.dispatch(TryUpdateCurrencyRateAction())
        store.dispatch(LoadLocalPurchasesAction(state: store.state))
        
        // Initialize the Google Mobile Ads SDK.
        GADMobileAds.configure(withApplicationID: AdMob.adMobId)
        
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

