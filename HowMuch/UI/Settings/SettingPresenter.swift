//
//  SettingPresenter.swift
//  HowMuch
//
//  Created by Максим Казаков on 13/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import Foundation

class SettingsPresenter {
    init() {
        let _ = SettingsService.shared
    }
    
    var sourceCurrency: Currency {
        return SettingsService.shared.sourceCurrency
    }
    
    var resultCurrency: Currency {
        return SettingsService.shared.resultCurrency
    }
    
    var tryParseFloat: Bool {
        return SettingsService.shared.tryParseFloat
    }
    
    func save(from: Currency? = nil, to: Currency? = nil) {
        SettingsService.shared.saveCurrency(from: from, to: to)
    }
    
    func saveTryParseFloat(value: Bool) {
//        SettingsService.shared.saveCurrency(from: from, to: to)
    }
}
