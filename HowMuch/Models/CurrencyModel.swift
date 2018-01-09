//
//  CurrenciesModel.swift
//  HowMuch
//
//  Created by Максим Казаков on 08/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import Foundation


enum CurrencyType: Int {
    case usd = 0
    case rub = 1
    case eur = 2
    case byn = 3
}



struct Currency {
    let type: CurrencyType
    let name: String
    let shortName: String
    let flag: Character
    
    
    static let usd = Currency(type: CurrencyType.usd, name: "Доллар США", shortName: "USD", flag: "🇺🇲" )
    static let rub = Currency(type: CurrencyType.rub, name: "Российский рубль", shortName: "RUB", flag: "🇷🇺" )
    static let eur = Currency(type: CurrencyType.eur, name: "Евро", shortName: "EUR", flag: "🇪🇺"  )
    static let byn = Currency(type: CurrencyType.byn, name: "Белорусский рубль", shortName: "BYN", flag: "🇧🇾" )
    
    static let all = [usd, rub, eur, byn]
}


