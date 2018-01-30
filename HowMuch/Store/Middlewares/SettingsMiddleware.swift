//
//  SettingsMiddleware.swift
//  HowMuch
//
//  Created by Максим Казаков on 28/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import ReSwift


let LoadSettingsMiddleware: Middleware<AppState> = { dispatch, getState in
    return { next in
        return { action in
            guard let initAction = action as? ReSwiftInit else {
                return next(action)
            }
            SettingsService.shared.loadSettings() { settings in
                dispatch(SetSettingsAction(settings: settings, needSave: false))
            }
            return next(action)
        }
    }
}



let SaveSettingsMiddleware: Middleware<AppState> = { dispatch, getState in
    return { next in
        return { action in
            var newSettings = Settings()
            let settingState = getState()!.settings
            
            switch action {
            case let settingAction as SetSettingsAction:
                guard settingAction.needSave else {
                    return next(action)
                }
            case let settingAction as SetSourceCurrencyAction:
                newSettings.sourceCurrency = settingAction.currency
            case let settingAction as SetResultCurrencyAction:
                newSettings.resultCurrency = settingAction.currency
            case let settingAction as SetParseToFloatAction:
                newSettings.tryParseFloat = settingAction.value
            default:
                break
            }
            SettingsService.shared.save(settings: newSettings)            
            return next(action)
        }
    }
}

