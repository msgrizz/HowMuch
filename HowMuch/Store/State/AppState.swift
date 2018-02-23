//
//  AppState.swift
//  HowMuch
//
//  Created by Максим Казаков on 28/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import ReSwift

struct AppState: StateType, Equatable {
    // Настройки приложения
    let settings: SettingsState
    // Курсы валют
    let currencyRates: CurrencyRatesState
    // Состояние экрана распознавания
    let recognizing: RecognizingState
    // Информация о покупках
    let purchaseState: PurchaseState
    
    static func ==(lhs: AppState, rhs: AppState) -> Bool {
        return lhs.settings == rhs.settings
            && lhs.currencyRates == rhs.currencyRates
            && lhs.recognizing == rhs.recognizing
            && lhs.purchaseState == rhs.purchaseState
    }
}
