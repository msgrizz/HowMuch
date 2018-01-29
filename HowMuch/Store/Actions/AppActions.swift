//
//  AppActions.swift
//  HowMuch
//
//  Created by Максим Казаков on 28/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import ReSwift


/// Установить исходное значение
struct SetSourceValueAction: Action {
    let value: Float
}


/// Установить статус распознавания
struct SetRecognizingStatusAction: Action {
    let status: RecongnizingStatus
}


/// Переключить статус распознавания
struct ToggleRecognizingStatus: Action {}




