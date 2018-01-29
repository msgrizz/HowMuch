//
//  CurrencyRatesActoins.swift
//  HowMuch
//
//  Created by Максим Казаков on 28/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import ReSwift

/// Задать значения курсов валют
struct SetCurrencyRatesAction: Action {
    let rates: [Currency : Float]
}


/// Обновить значения курсов валют
struct UpdateCurrencyRateAction: Action { }
