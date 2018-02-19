//
//  RecognizingReducer.swift
//  HowMuch
//
//  Created by Максим Казаков on 28/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import ReSwift

func RecognizingReducer(action: Action, state: RecognizingState?) -> RecognizingState {
    var state = state ?? initState()
    switch action {
    case let setValues as SetValuesAction:
        state.sourceValue = setValues.source
        state.resultValue = setValues.result
        return state
    case let setRecognizingStatus as SetRecognizingStatusAction:
        state.recongnizingStatus = setRecognizingStatus.status
        return state
    case let setIsManualEdtitingAction as SetIsManualEdtitingAction:
        state.isManuallyEditing = setIsManualEdtitingAction.value
        return state
    default:
        return state
    }    
}


private func initState() -> RecognizingState {
    return RecognizingState.default
}
