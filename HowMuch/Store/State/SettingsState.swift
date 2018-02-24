//
//  SettingsState.swift
//  HowMuch
//
//  Created by Максим Казаков on 28/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import ReSwift

struct SettingsState: StateType, Equatable {
    let sourceCurrency: Currency
    let resultCurrency: Currency
    let tryParseFloat: Bool
    
    static let `default` =  SettingsState(sourceCurrency: .RUB, resultCurrency: .USD, tryParseFloat: true)
    
    static func ==(lhs: SettingsState, rhs: SettingsState) -> Bool {
        return lhs.sourceCurrency == rhs.sourceCurrency
            && lhs.resultCurrency == rhs.resultCurrency
            && lhs.tryParseFloat == rhs.tryParseFloat
    }
}
