//
//  SettingsService.swift
//  HowMuch
//
//  Created by Максим Казаков on 13/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import Foundation

class Settings {
    var sourceCurrency: Currency
    var resultCurrency: Currency
    var tryParseFloat: Bool
    
    init(sourceCurrency: Currency = .usd, resultCurrency: Currency = .rub, tryParseFloatCurrency: Bool = false) {
        self.sourceCurrency = sourceCurrency
        self.resultCurrency = resultCurrency
        self.tryParseFloat = tryParseFloatCurrency
    }
}


class SettingsService {
    static var shared = SettingsService()
    
    
    func saveTryParseFloat(value: Bool) {
        settings.tryParseFloat = value
        UserDefaults.standard.set(value, forKey: SettingsService.tryParseFloatKey)
    }
    
    
    func saveCurrency(from: Currency? = nil, to: Currency? = nil) {
        let userDefaults = UserDefaults.standard
        if let from = from {
            settings.sourceCurrency = from
            userDefaults.set(from.type.rawValue, forKey: SettingsService.fromCurrencyKey)
        }
        if let to = to {
            settings.resultCurrency = to
            userDefaults.set(to.type.rawValue, forKey: SettingsService.toCurrencyKey)
        }
    }
    
    
    
    var sourceCurrency: Currency {
        return settings.sourceCurrency
    }
    
    
    var resultCurrency: Currency {
        return settings.resultCurrency
    }
    
    
    var currentCurrency: (from: Currency, to: Currency) {
        return (settings.sourceCurrency, settings.resultCurrency)
    }
    
    
    
    var tryParseFloat: Bool {
        return settings.tryParseFloat
    }
    
    // MARK: -Private
    
    private init() {
        loadCurrency()
    }
    
    
    private static let fromCurrencyKey = "fromCurrency"
    private static let toCurrencyKey = "toCurrency"
    private static let tryParseFloatKey = "tryParseFloat"
    
    
    private var settings = Settings()
    
    
    private func loadCurrency() {
        let userDefaults = UserDefaults.standard
        let from = CurrencyType(rawValue: userDefaults.string(forKey: SettingsService.fromCurrencyKey) ?? "")
        let to = CurrencyType(rawValue: userDefaults.string(forKey: SettingsService.toCurrencyKey) ?? "")
        let tryParseFloat = userDefaults.bool(forKey: SettingsService.tryParseFloatKey)
        settings = Settings(sourceCurrency: Currency.all.first{$0.type == from} ?? .usd,
                            resultCurrency: Currency.all.first{$0.type == to} ?? .rub,
                            tryParseFloatCurrency: tryParseFloat)
    }
}

