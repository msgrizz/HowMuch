//
//  Observer.swift
//  HowMuch
//
//  Created by Максим Казаков on 17/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import Foundation


class ObserverList<ObserverType> {
    private var _observers = NSHashTable<AnyObject>.weakObjects()
    
    func add(observer: ObserverType) {
        _observers.add(observer as AnyObject)
    }
    
    
    
    func remove(observer: ObserverType) {
        _observers.remove(observer as AnyObject)
    }

    
    
    var observers: [ObserverType] {
        return _observers.allObjects as! [ObserverType]
    }
}
