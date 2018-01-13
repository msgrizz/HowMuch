//
//  CameraPresenter.swift
//  HowMuch
//
//  Created by Максим Казаков on 13/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import UIKit


class CameraPresenter {    
    
    init() {
        let _ = CurrencyService.shared
    }
    
    var signs: (from: Character, to: Character) {
        let current = currencies
        return (current.from.sign, current.to.sign)
    }
    
    
    
    var currencies: (from: Currency, to: Currency) {
        let currentCurrencies = SettingsService.shared.getCurrentCurrency
        return currentCurrencies
    }
    
    
    
    func calculate(from value: Float) -> Float {
        let current = currencies
        let ratio = CurrencyService.shared.getRate(from: current.from.type, to: current.to.type)
        return ratio * value
    }
}
