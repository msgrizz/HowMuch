//
//  CameraPresenter.swift
//  HowMuch
//
//  Created by Максим Казаков on 13/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import UIKit


protocol CameraView: class {
    func set(settings: Settings)
}


class CameraPresenter {
    weak var view: CameraView?
    
    init(view: CameraView) {
        self.view = view
    }
    
    
    func fetch() {
        Services.settings.loadSettings { [weak self] settings in
            guard let strong = self else {
                return
            }
            strong.view?.set(settings: settings)
        }
    }
    
    
    
    func calculate(sourceCurrency: CurrencyType, resultCurrency: CurrencyType, from value: Float) -> Float {
        let ratio = CurrencyService.shared.getRate(from: sourceCurrency, to: resultCurrency)
        return ratio * value
    }
    
    
    
    func save(settings: Settings) {
        return Services.settings.save(settings: settings)
    }
}
