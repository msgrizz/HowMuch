//
//  SettingsService.swift
//  HowMuch
//
//  Created by Максим Казаков on 13/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import Foundation

class SettingsService {
    static var shared = SettingsService()
    
    
    func saveCurrency(from: Currency, to: Currency) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(from.type.rawValue, forKey: SettingsService.fromCurrencyKey)
        userDefaults.set(to.type.rawValue, forKey: SettingsService.toCurrencyKey)
    }
    
    
    func loadCurrency() -> (from: Currency, to: Currency) {
        let userDefaults = UserDefaults.standard
        let fromType = CurrencyType(rawValue: userDefaults.string(forKey: SettingsService.fromCurrencyKey) ?? "")
        let toType = CurrencyType(rawValue: userDefaults.string(forKey: SettingsService.toCurrencyKey) ?? "")
        currentFromCurrency = Currency.all.first { $0.type == fromType } ?? currentFromCurrency
        currentToCurrency = Currency.all.first { $0.type == toType } ?? currentToCurrency
        return (currentFromCurrency, currentToCurrency)
    }
    
    
    var getCurrentCurrency: (from: Currency, to: Currency) {
        return (currentFromCurrency, currentToCurrency)
    }
    
    
    private static let fromCurrencyKey = "fromCurrency"
    private static let toCurrencyKey = "toCurrency"
    
    private var currentFromCurrency = Currency.rub
    private var currentToCurrency = Currency.usd
}

