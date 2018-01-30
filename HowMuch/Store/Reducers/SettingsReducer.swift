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
    let oldSettings = state.settings
    
    switch action {
    case let setSettings as SetSettingsAction:
         return SettingsState(settings: setSettings.settings)
    case let setSourceCurrency as SetSourceCurrencyAction:
        let settings = Settings(sourceCurrency: setSourceCurrency.currency, resultCurrency: oldSettings.resultCurrency, tryParseFloatCurrency: oldSettings.tryParseFloat)
        return SettingsState(settings: settings)
    case let setResultCurrency as SetResultCurrencyAction:
        let settings = Settings(sourceCurrency: oldSettings.sourceCurrency, resultCurrency: setResultCurrency.currency, tryParseFloatCurrency: oldSettings.tryParseFloat)
        return SettingsState(settings: settings)
    case let setParseToFloat as SetParseToFloatAction:
        let settings = Settings(sourceCurrency: oldSettings.sourceCurrency, resultCurrency: oldSettings.resultCurrency, tryParseFloatCurrency: setParseToFloat.value)
        return SettingsState(settings: settings)
    default:
        return state
    }
}



func initState() -> SettingsState {
    return SettingsState.default
}
