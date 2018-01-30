//
//  SettingsReducer.swift
//  HowMuch
//
//  Created by Максим Казаков on 28/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import ReSwift

func SettingsReducer(action: Action, state: SettingsState?) -> SettingsState {
    let state = state ?? initState()
    
    switch action {
    case let setSettings as LoadedSettingsAction:
         return setSettings.settings
        
    case let setSourceCurrency as SetSourceCurrencyAction:
        return SettingsState(sourceCurrency: setSourceCurrency.currency, resultCurrency: state.resultCurrency, tryParseFloat: state.tryParseFloat)
        
    case let setResultCurrency as SetResultCurrencyAction:
        return SettingsState(sourceCurrency: state.sourceCurrency, resultCurrency: setResultCurrency.currency, tryParseFloat: state.tryParseFloat)
        
    case let setParseToFloat as SetParseToFloatAction:
        return SettingsState(sourceCurrency: state.sourceCurrency, resultCurrency: state.resultCurrency, tryParseFloat: setParseToFloat.value)
        
    default:
        return state
    }
}



func initState() -> SettingsState {
    return SettingsState.default
}
