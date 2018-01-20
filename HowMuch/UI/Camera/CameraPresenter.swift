//
//  CameraPresenter.swift
//  HowMuch
//
//  Created by Максим Казаков on 13/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import UIKit


class CameraPresenter: SettingsObserver {
    
    
    // MARK: -SettingsObserver
    func onChange(settings: Settings) {
        self.settings = settings
    }
    
    
    init() {
        settings = Services.settings.settings
        Services.settings.add(observer: self)
    }
    
    
    
    var signs: (from: Character, to: Character) {
        let current = currencies
        return (current.from.sign, current.to.sign)
    }
    
    
    var tryParseFloat: Bool {
        return settings.tryParseFloat
    }
    
    
    
    var currencies: (from: Currency, to: Currency) {
        return (settings.sourceCurrency, settings.resultCurrency)
    }
    
    
    
    func calculate(from value: Float) -> Float {
        let current = currencies
        let ratio = CurrencyService.shared.getRate(from: current.from.type, to: current.to.type)
        return ratio * value
    }
    
    
    private var settings: Settings
}
