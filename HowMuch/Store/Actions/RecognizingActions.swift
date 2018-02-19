//
//  AppActions.swift
//  HowMuch
//
//  Created by Максим Казаков on 28/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import ReSwift


/// Установить значения
struct SetValuesAction: Action {
    let source: Float
    let result: Float
}


/// Установить статус распознавания
struct SetRecognizingStatusAction: Action {
    let status: RecongnizingStatus
}

/// Установить статус распознавания
struct SetIsManualEdtitingAction: Action {
    let value: Bool
}
