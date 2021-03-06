//
//  CurrencyRatesMiddleware.swift
//  HowMuch
//
//  Created by Максим Казаков on 28/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import ReSwift


let LoadCurrencyRatesMiddleware: Middleware<AppState> = { dispatch, getState in
    return { next in
        return { action in
            guard let initAction = action as? ReSwiftInit else {
                return next(action)
            }
            DispatchQueue.global(qos: .userInitiated).async {
                if let rates = CurrencyService.shared.loadFromLocalStorage() {
                    DispatchQueue.main.async {
                        dispatch(SetCurrencyRatesAction(rates: rates))
                    }                    
                }
            }
            return next(action)
        }
    }
}



let UpdateCurrencyRatesMiddleware: Middleware<AppState> = { dispatch, getState in
    return { next in
        return { action in
            guard let initAction = action as? TryUpdateCurrencyRateAction,
                let state = getState() else {
                return next(action)
            }
            let oldRates = state.currencyRates.rates
            CurrencyService.shared.updateIfNeeded { newRates in                
                let rates = oldRates.merging(newRates, uniquingKeysWith: { $1 })
                CurrencyService.shared.saveToLocalStorage(rates: rates)
                dispatch(UpdateCurrencyRatesAction(rates: rates))
            }
        }
    }
}
