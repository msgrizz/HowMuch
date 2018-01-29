//
//  SettingsReducer.swift
//  HowMuch
//
//  Created by Максим Казаков on 28/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import ReSwift

func SettingsReducer(action: Action, state: SettingsState?) -> SettingsState {
    let state = state ?? initState()
    
    return state    
}



func initState() -> SettingsState {
    return SettingsState.default
}
