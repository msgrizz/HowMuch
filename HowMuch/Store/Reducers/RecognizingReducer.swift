//
//  RecognizingReducer.swift
//  HowMuch
//
//  Created by Максим Казаков on 28/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import ReSwift

func RecognizingReducer(action: Action, state: RecognizingState?) -> RecognizingState {
    let state = state ?? initState()
    return state
}



func initState() -> RecognizingState {
    return RecognizingState.default
}
