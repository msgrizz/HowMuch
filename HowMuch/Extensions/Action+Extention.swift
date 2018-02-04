//
//  Action+Extention.swift
//  HowMuch
//
//  Created by Максим Казаков on 04/02/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import ReSwift


protocol CustomActionStringConvertable: CustomStringConvertible {
    var payloadDescription: String { get }
}


extension Action where Self: CustomActionStringConvertable {
    var description: String {
        let typeVar = type(of: self)
        return String(describing: typeVar) + "(\(payloadDescription))"
    }
}


