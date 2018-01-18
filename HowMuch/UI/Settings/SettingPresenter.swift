//
//  SettingPresenter.swift
//  HowMuch
//
//  Created by Максим Казаков on 13/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import Foundation

class SettingsPresenter {

    func save(settings: Settings) {
        Services.settings.save(settings: settings)
    }
    
    var settings: Settings {
        return Services.settings.settings
    }
}
