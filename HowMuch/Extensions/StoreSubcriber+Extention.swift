//
//  StoreSubcriber+Extention.swift
//  HowMuch
//
//  Created by Максим Казаков on 08/02/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import ReSwift

protocol SimpleStoreSubscriber: StoreSubscriber {
    associatedtype SubState
    var onStateChanged: ((Self, SubState) -> Void)! { get set }
}


extension SimpleStoreSubscriber {
    func connect(select: @escaping (AppState) -> StoreSubscriberStateType,
                 isChanged: @escaping (StoreSubscriberStateType, StoreSubscriberStateType) -> Bool,
                 onChanged: @escaping (Self, SubState) -> Void) {
        
        onStateChanged = onChanged
        
        store.subscribe(self) { subscription in
            subscription
                .select(select)
                .skipRepeats { !isChanged($0, $1) }
        }
    }
    
    func newState(state: SubState) {
        onStateChanged(self, state)
    }
}
