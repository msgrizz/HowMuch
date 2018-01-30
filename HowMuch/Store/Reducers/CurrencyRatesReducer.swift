//
//  CurrenciesReducer.swift
//  HowMuch
//
//  Created by Максим Казаков on 28/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import ReSwift

func CurrencyRatesReducer(action: Action, state: CurrencyRatesState?) -> CurrencyRatesState {
    let state = state ?? initState()
    
    switch action {
    case let setCurrencyRates as SetCurrencyRatesAction:
        return CurrencyRatesState(rates: setCurrencyRates.rates)
    default:
        return state
    }
}



func initState() -> CurrencyRatesState {
    return CurrencyRatesState.default
}
