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

var store = Store<AppState>(
    reducer: AppReducer,
    state: nil,
    middleware: [LoggingMiddleware, LoadCurrencyRatesMiddleware, UpdateCurrencyRatesMiddleware, LoadSettingsMiddleware, SaveSettingsMiddleware])


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let appearance = UINavigationBar.appearance()
//        appearance.isTranslucent = false
//        appearance.barTintColor = Colors.accent2
        appearance.tintColor = Colors.accent1
//        let textAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
//        appearance.titleTextAttributes = textAttributes
        
        let pictureListVc = RecognizerViewController()
        let initialViewController = UINavigationController(rootViewController: pictureListVc)
        initialViewController.navigationBar.prefersLargeTitles = true
        window!.rootViewController = initialViewController
        window!.makeKeyAndVisible()
        
        store.dispatch(TryUpdateCurrencyRateAction())
        return true
    }
    
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        store.dispatch(TryUpdateCurrencyRateAction())
        
        StoreReviewHelper.incrementAppOpenedCounter()
        StoreReviewHelper.checkAndAskForReview()
    }
}

