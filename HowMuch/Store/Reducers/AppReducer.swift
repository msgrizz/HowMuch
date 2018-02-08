//
//  AppReducer.swift
//  HowMuch
//
//  Created by Максим Казаков on 28/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import ReSwift

func AppReducer(action: Action, state: AppState?) -> AppState {
    return AppState(
        settings: SettingsReducer(action: action, state: state?.settings),
        currencyRates: CurrencyRatesReducer(action: action, state: state?.currencyRates),
        recognizing: RecognizingReducer(action: action, state: state?.recognizing),
        selectionCurrencyState: SelectionCurrencyState(filteredCurrencies: [])
    )
}

