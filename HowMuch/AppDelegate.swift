//
//  AppDelegate.swift
//  Text Detection Starter Project
//
//  Created by Sai Kambampati on 6/21/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let pictureListVc = CameraViewController()
        let initialViewController = UINavigationController(rootViewController: pictureListVc)
        
        window!.rootViewController = initialViewController
        window!.makeKeyAndVisible()
        
        CurrencyService.shared.updateIfNeeded()
        return true
    }
    
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        CurrencyService.shared.updateIfNeeded()
    }
}

