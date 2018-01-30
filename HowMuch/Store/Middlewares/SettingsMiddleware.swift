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
                dispatch(LoadedSettingsAction(settings: settings))
            }
            return next(action)
        }
    }
}



let SaveSettingsMiddleware: Middleware<AppState> = { dispatch, getState in
    return { next in
        return { action in
            switch action {
            case let settingAction as SetSourceCurrencyAction:
                SettingsService.shared.save(sourceCurrency: settingAction.currency)
            case let settingAction as SetResultCurrencyAction:
                SettingsService.shared.save(resultCurrency: settingAction.currency)
            case let settingAction as SetParseToFloatAction:
                SettingsService.shared.save(tryParseFloat: settingAction.value)
            default:
                break
            }
            return next(action)
        }
    }
}

