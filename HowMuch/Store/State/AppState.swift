//
//  AppState.swift
//  HowMuch
//
//  Created by Максим Казаков on 28/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import ReSwift

struct AppState: StateType {
    let settings: SettingsState
    let currencyRates: CurrencyRatesState
    let recognizing: RecognizingState
}
