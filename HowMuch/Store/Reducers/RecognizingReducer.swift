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
    
    switch action {
    case let setValues as SetValuesAction:
        return RecognizingState(sourceValue: setValues.source, resultValue: setValues.result, recongnizingStatus: state.recongnizingStatus)
    case let setRecognizingStatus as SetRecognizingStatusAction:
        return RecognizingState(sourceValue: state.sourceValue, resultValue: state.resultValue, recongnizingStatus: setRecognizingStatus.status)    
    default:
        return state
    }    
}


private func initState() -> RecognizingState {
    return RecognizingState.default
}
