//
//  RecognizingState.swift
//  HowMuch
//
//  Created by Максим Казаков on 28/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import ReSwift

enum RecongnizingStatus: Equatable {
    case noCameraAccess
    case running
    case suspended
    case stopped
    
    var isRunning: Bool { return self == .running }
}

struct RecognizingState: StateType, Equatable {
    var sourceValue: Float
    var resultValue: Float
    var isManuallyEditing: Bool
    var recongnizingStatus: RecongnizingStatus
    
    static let `default` = RecognizingState(sourceValue: 0.0, resultValue: 0.0, isManuallyEditing: false, recongnizingStatus: .stopped)
    
    static func ==(lhs: RecognizingState, rhs: RecognizingState) -> Bool {
        return lhs.sourceValue == rhs.sourceValue
            && lhs.resultValue == rhs.resultValue
            && lhs.recongnizingStatus == rhs.recongnizingStatus
            && lhs.isManuallyEditing == rhs.isManuallyEditing
    }
}
