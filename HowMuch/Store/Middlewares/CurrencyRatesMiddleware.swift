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
            DispatchQueue.main.async {
                if let rates = CurrencyService.shared.loadFromLocalStorage() {
                    dispatch(SetCurrencyRatesAction(rates: rates))
                }
            }
            next(action)
        }
    }
}



let UpdateCurrencyRatesMiddleware: Middleware<AppState> = { dispatch, getState in
    return { next in
        return { action in
            guard let initAction = action as? UpdateCurrencyRateAction else {
                return
            }
            let oldRates = getState()!.currencyRates.rates
            CurrencyService.shared.updateIfNeeded { newRates in                
                let rates = oldRates.merging(newRates, uniquingKeysWith: { $1 })
                CurrencyService.shared.saveToLocalStorage(rates: newRates)
                dispatch(SetCurrencyRatesAction(rates: rates))
            }
        }
    }
}
