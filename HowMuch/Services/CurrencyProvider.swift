//
//  CurrencyProvider.swift
//  HowMuch
//
//  Created by Максим Казаков on 09/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import Foundation

class CurrencyProvider {
    static var shared = CurrencyProvider()
    

    func getRate(from: CurrencyType, to: CurrencyType) -> Float {
        let fromRate = rates[from]!
        let toRate = rates[to]!
        return fromRate / toRate
    }
    
    

    // MARK: -Private
    static let defaultRetes: [CurrencyType : Float] = [
        .usd : 1,
        .rub : 0.01755,
        .eur: 1.19209,
        .byn: 0.50
    ]
    private var rates: [CurrencyType : Float] = CurrencyProvider.defaultRetes
    private static let currencyRatesKey = "CurrencyRates"
    
    
    
    private init() {
        if let rates = loadFromLocalStorage() {
            self.rates = rates
        }
        syncRates()
    }
    
    
    
    
    private func saveToLocalStorage(rates: [CurrencyType : Float]) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(rates, forKey: CurrencyProvider.currencyRatesKey)
    }
    
    
    
    private func loadFromLocalStorage() -> [CurrencyType : Float]? {
        let userDefaults = UserDefaults.standard
        guard let rates = userDefaults.dictionary(forKey: CurrencyProvider.currencyRatesKey) else {
            return nil
        }
        
        return Dictionary(uniqueKeysWithValues: rates.flatMap { key, value in
            guard let intKey = Int(key),
                let currencyType = CurrencyType(rawValue: intKey),
                let value = value as? Float
                else {
                return nil
            }
            return (currencyType, value)
        })
    }
    
    
    
    func syncRates() {
        
    }
}
