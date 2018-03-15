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
    
    func loadSettings(onComplete: @escaping (SettingsState) -> Void) {
        let defaults = UserDefaults.standard
        let source = Currency(rawValue: defaults.string(forKey: Keys.fromCurrencyKey) ?? "")
        let result = Currency(rawValue: defaults.string(forKey: Keys.toCurrencyKey) ?? "")
        var tryParseFloat = true
        if let value = defaults.object(forKey: Keys.tryParseFloatKey) as? Bool {
            tryParseFloat = value
        }
        let settings = SettingsState(sourceCurrency: source ?? .RUB,
                                     resultCurrency: result ?? .USD,
                                     tryParseFloat: tryParseFloat)
        DispatchQueue.main.async {
            onComplete(settings)
        }
        
    }
    
    
    func save(settings: SettingsState) {
        let defaults = UserDefaults.standard
        defaults.set(settings.sourceCurrency.rawValue, forKey: Keys.fromCurrencyKey)
        defaults.set(settings.resultCurrency.rawValue, forKey: Keys.toCurrencyKey)
        defaults.set(settings.tryParseFloat, forKey: Keys.tryParseFloatKey)
    }
    
    
    func save(sourceCurrency: Currency) {
        let defaults = UserDefaults.standard
        defaults.set(sourceCurrency.rawValue, forKey: Keys.fromCurrencyKey)
    }
    
    
    func save(resultCurrency: Currency) {
        let defaults = UserDefaults.standard
        defaults.set(resultCurrency.rawValue, forKey: Keys.toCurrencyKey)
    }
    
    
    func save(tryParseFloat: Bool) {
        let defaults = UserDefaults.standard
        defaults.set(tryParseFloat, forKey: Keys.tryParseFloatKey)
    }
    
    
    // MARK: -Private
    private struct Keys {
        static let fromCurrencyKey = "fromCurrency"
        static let toCurrencyKey = "toCurrency"
        static let tryParseFloatKey = "tryParseFloat"
    }
    
    
    private init() {}
}

