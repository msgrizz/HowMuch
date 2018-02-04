//
//  CurrencyRatesActoins.swift
//  HowMuch
//
//  Created by Максим Казаков on 28/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import ReSwift

/// Считанные с диска курсы валют
struct SetCurrencyRatesAction: Action, CustomActionStringConvertable  {
    let rates: [Currency : Float]
    
    var payloadDescription: String {
        return "Rates count: \(rates.count)"
    }
}


/// Загруженные из сети курсы валют
struct UpdateCurrencyRatesAction: Action, CustomActionStringConvertable  {
    let rates: [Currency : Float]
    
    var payloadDescription: String {
        return "Rates count: \(rates.count)"
    }
}

/// Обновить значения курсов валют
struct TryUpdateCurrencyRateAction: Action { }
