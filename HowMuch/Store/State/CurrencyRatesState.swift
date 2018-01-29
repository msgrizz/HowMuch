//
//  CurrenciesState.swift
//  HowMuch
//
//  Created by Максим Казаков on 28/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import ReSwift

struct CurrencyRatesState: StateType {
    let rates: [Currency : Float]
    
    static let `default` = CurrencyRatesState(rates: defaultRetes)

    static let defaultRetes: [Currency : Float] = [
        .usd : 1,
        .rub : 56.66,
        .eur: 0.82,
        .byn: 2.0
    ]
}
