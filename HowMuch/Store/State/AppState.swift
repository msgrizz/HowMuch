//
//  AppState.swift
//  HowMuch
//
//  Created by Максим Казаков on 28/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import ReSwift

struct AppState: StateType, Equatable {
    let settings: SettingsState
    let currencyRates: CurrencyRatesState
    let recognizing: RecognizingState
    let selectionCurrencyState: SelectionCurrencyState
    
    static func ==(lhs: AppState, rhs: AppState) -> Bool {
        return lhs.settings == rhs.settings
            && lhs.currencyRates == rhs.currencyRates
            && lhs.recognizing == rhs.recognizing
            && lhs.selectionCurrencyState == rhs.selectionCurrencyState
    }
}


struct SelectionCurrencyState: Equatable {
    static func ==(lhs: SelectionCurrencyState, rhs: SelectionCurrencyState) -> Bool {
        return lhs.filteredCurrencies == rhs.filteredCurrencies
    }
    
    let filteredCurrencies: [Currency]
}
