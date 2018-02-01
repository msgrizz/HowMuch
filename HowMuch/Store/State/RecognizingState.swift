//
//  RecognizingState.swift
//  HowMuch
//
//  Created by Максим Казаков on 28/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import ReSwift

enum RecongnizingStatus: Equatable {
    /// не обрабатываются кадры
    case stopped
    /// не обрабатываются кадры, экран заглушки
    case suspended
    /// запущено
    case running
}

struct RecognizingState: StateType {
    let sourceValue: Float
    let resultValue: Float
    let recongnizingStatus: RecongnizingStatus
    let isManuallyEditing: Bool
//    let accessToCamera: Bool
    
    static let `default` = RecognizingState(sourceValue: 0.0, resultValue: 0.0, recongnizingStatus: .running, isManuallyEditing: false)
}
