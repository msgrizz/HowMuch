//
//  LoggingMiddleware.swift
//  HowMuch
//
//  Created by Максим Казаков on 30/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import ReSwift

let LoggingMiddleware: Middleware<AppState> = { dispatch, state in
    return { next in
        return { action in
            // perform middleware logic
            print(action)            
            // call next middleware
            return next(action)
        }
    }
}
