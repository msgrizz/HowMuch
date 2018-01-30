//
//  SettingsState.swift
//  HowMuch
//
//  Created by Максим Казаков on 28/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import ReSwift

struct SettingsState: StateType {
    let sourceCurrency: Currency
    let resultCurrency: Currency
    let tryParseFloat: Bool
    
    static let `default` =  SettingsState(sourceCurrency: .usd, resultCurrency: .rub, tryParseFloat: true)
}
