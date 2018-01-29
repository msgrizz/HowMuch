//
//  SettingsState.swift
//  HowMuch
//
//  Created by Максим Казаков on 28/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import ReSwift

struct SettingsState: StateType {
    let settings: Settings
    
    static let `default` = SettingsState(settings: Settings())
}
