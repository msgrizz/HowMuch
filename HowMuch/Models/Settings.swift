//
//  Settings.swift
//  HowMuch
//
//  Created by Максим Казаков on 17/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import Foundation

struct Settings {
    var sourceCurrency: Currency
    var resultCurrency: Currency
    var tryParseFloat: Bool
    
    init(sourceCurrency: Currency = .usd, resultCurrency: Currency = .rub, tryParseFloatCurrency: Bool = false) {
        self.sourceCurrency = sourceCurrency
        self.resultCurrency = resultCurrency
        self.tryParseFloat = tryParseFloatCurrency
    }
}
