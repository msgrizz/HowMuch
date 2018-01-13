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
    
    
    func saveCurrency(from: Currency? = nil, to: Currency? = nil) {
        let userDefaults = UserDefaults.standard
        if let from = from {
            currentFromCurrency = from
            userDefaults.set(from.type.rawValue, forKey: SettingsService.fromCurrencyKey)
        }
        if let to = to {
            currentToCurrency = to
            userDefaults.set(to.type.rawValue, forKey: SettingsService.toCurrencyKey)
        }
    }
    
    
    func loadCurrency() {
        let userDefaults = UserDefaults.standard
        let fromType = CurrencyType(rawValue: userDefaults.string(forKey: SettingsService.fromCurrencyKey) ?? "")
        let toType = CurrencyType(rawValue: userDefaults.string(forKey: SettingsService.toCurrencyKey) ?? "")
        currentFromCurrency = Currency.all.first { $0.type == fromType } ?? currentFromCurrency
        currentToCurrency = Currency.all.first { $0.type == toType } ?? currentToCurrency
    }
    
    
    var sourceCurrency: Currency {
        return currentFromCurrency
    }
    
    
    var resultCurrency: Currency {
        return currentToCurrency
    }
    
    
    var currentCurrency: (from: Currency, to: Currency) {
        return (currentFromCurrency, currentToCurrency)
    }
    
    
    // MARK: -Private
    
    private init() {
        loadCurrency()
    }
    
    
    private static let fromCurrencyKey = "fromCurrency"
    private static let toCurrencyKey = "toCurrency"
    
    private var currentFromCurrency = Currency.rub
    private var currentToCurrency = Currency.usd
}

