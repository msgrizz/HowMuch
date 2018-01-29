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
    return state
}



func initState() -> CurrencyRatesState {
    return CurrencyRatesState.default
}
