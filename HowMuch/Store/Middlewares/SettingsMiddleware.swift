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
            next(action)
        }
    }
}



let SaveSettingsMiddleware: Middleware<AppState> = { dispatch, getState in
    return { next in
        return { action in
            defer {
                next(action)
            }
            var newSettings: Settings
            let settingState = getState()!.settings            
            switch action {
            case let settingAction as SetSettingsAction:
                guard settingAction.needSave else {
                    return
                }
                newSettings = settingAction.settings
            case let settingAction as SetSourceCurrencyAction:
                newSettings = Settings()
            case let settingAction as SetResultCurrencyAction:
                newSettings = Settings()
            case let settingAction as SetParseToFloatAction:
                newSettings = Settings()
            default:
                return
            }
            SettingsService.shared.save(settings: newSettings)
            dispatch(SetSettingsAction(settings: newSettings, needSave: false))
        }
    }
}

