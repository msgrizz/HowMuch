//
//  SettingsService.swift
//  HowMuch
//
//  Created by Максим Казаков on 13/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import Foundation


protocol SettingsObserver: class {
    func onChange(settings: Settings)
}


protocol SettingsService {
    var settings: Settings { get }
    func add(observer: SettingsObserver)
    func remove(observer: SettingsObserver)
    func save(settings: Settings)
}


class SettingsServiceImpl: SettingsService {        
    // MARK: - SettingsService
    
    var settings = Settings() {
        didSet {
            let defaults = UserDefaults.standard
            defaults.set(settings.sourceCurrency.type.rawValue, forKey: Keys.fromCurrencyKey)
            defaults.set(settings.resultCurrency.type.rawValue, forKey: Keys.toCurrencyKey)
            defaults.set(settings.tryParseFloat, forKey: Keys.tryParseFloatKey)
            notify()
        }
    }
    
    func add(observer: SettingsObserver) {
        observerList.add(observer: observer)
        observer.onChange(settings: settings)
    }
    
    
    
    func remove(observer: SettingsObserver) {
        observerList.remove(observer: observer)
    }
    
    
    
    func save(settings: Settings) {
        self.settings = settings
    }

    
    // MARK: -Private
    private var observerList = ObserverList<SettingsObserver>()
    private struct Keys {
        static let fromCurrencyKey = "fromCurrency"
        static let toCurrencyKey = "toCurrency"
        static let tryParseFloatKey = "tryParseFloat"
    }
    
    
    init() {
        loadCurrency()
    }
    
    
    private func notify() {
        observerList.observers.forEach{ $0.onChange(settings: settings) }
    }
    
    
    
    private func loadCurrency() {
        let defaults = UserDefaults.standard
        let from = CurrencyType(rawValue: defaults.string(forKey: Keys.fromCurrencyKey) ?? "")
        let to = CurrencyType(rawValue: defaults.string(forKey: Keys.toCurrencyKey) ?? "")
        let tryParseFloat = defaults.bool(forKey: Keys.tryParseFloatKey)
        settings = Settings(sourceCurrency: Currency.all.first{$0.type == from} ?? .usd,
                            resultCurrency: Currency.all.first{$0.type == to} ?? .rub,
                            tryParseFloatCurrency: tryParseFloat)
    }
}

