//
//  SettingsService.swift
//  HowMuch
//
//  Created by Максим Казаков on 13/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import Foundation


class SettingsService {
    
    // MARK: - SettingsService
    
    static let shared = SettingsService()
    
    func loadSettings(onComplete: @escaping (Settings) -> Void) {
        let defaults = UserDefaults.standard
        settingQueue.async {
            let source = Currency(rawValue: defaults.string(forKey: Keys.fromCurrencyKey) ?? "")
            let result = Currency(rawValue: defaults.string(forKey: Keys.toCurrencyKey) ?? "")
            let tryParseFloat = defaults.bool(forKey: Keys.tryParseFloatKey)
            let settings = Settings(sourceCurrency: source ?? .usd,
                                resultCurrency: result ?? .rub,
                                tryParseFloatCurrency: tryParseFloat)
            DispatchQueue.main.async {
                onComplete(settings)
            }
        }
    }
    
    
    func save(settings: Settings) {
        settingQueue.async {
            let defaults = UserDefaults.standard
            defaults.set(settings.sourceCurrency.rawValue, forKey: Keys.fromCurrencyKey)
            defaults.set(settings.resultCurrency.rawValue, forKey: Keys.toCurrencyKey)
            defaults.set(settings.tryParseFloat, forKey: Keys.tryParseFloatKey)
        }
    }

    
    
    // MARK: -Private
    private let settingQueue = DispatchQueue(label: "settings")
    private struct Keys {
        static let fromCurrencyKey = "fromCurrency"
        static let toCurrencyKey = "toCurrency"
        static let tryParseFloatKey = "tryParseFloat"
    }
    
    
    private init() {}
}

