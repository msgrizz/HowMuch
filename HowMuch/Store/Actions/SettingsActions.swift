//
//  SettingsActions.swift
//  HowMuch
//
//  Created by Максим Казаков on 28/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import ReSwift


/// Установить настройки
struct LoadedSettingsAction: Action {
    /// настройки
    let settings: SettingsState
}


/// Задать исходную валюту
struct SetSourceCurrencyAction: Action {
    let currency: Currency
}


/// Задать результирующую валюту
struct SetResultCurrencyAction: Action {
    let currency: Currency
}


/// Задать опцию необходимости распознавать после запятой
struct SetParseToFloatAction: Action {
    let value: Bool
}
