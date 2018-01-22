//
//  SettingPresenter.swift
//  HowMuch
//
//  Created by Максим Казаков on 13/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import Foundation

protocol SettingsView: class {
    func set(settings: Settings)
}


class SettingsPresenter {
    weak var view: SettingsView?
    
    
    init(view: SettingsView) {
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
    
    
    
    func save(settings: Settings) {
        return Services.settings.save(settings: settings)
    }
}
