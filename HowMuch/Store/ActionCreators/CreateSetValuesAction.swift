//
//  GetSetValuesAction.swift
//  HowMuch
//
//  Created by Максим Казаков on 30/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import ReSwift

func CreateSetValuesAction(state: AppState, source: Float) -> SetValuesAction {
    let sourceCurrency = state.settings.settings.sourceCurrency
    let resultCurrency = state.settings.settings.resultCurrency
    
    let sourceRate = state.currencyRates.rates[sourceCurrency] ?? 1.0
    let resultRate = state.currencyRates.rates[resultCurrency] ?? 1.0
    let ratio = sourceRate / resultRate
    let result = source * ratio
    
    return SetValuesAction(source: source, result: result)
}
