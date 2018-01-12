//
//  CurrenciesModel.swift
//  HowMuch
//
//  Created by Максим Казаков on 08/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import Foundation


enum CurrencyType: String {
    case usd = "USD"
    case rub = "RUB"
    case eur = "EUR"
    case byn = "BYN"
}



struct Currency {
    let type: CurrencyType
    let name: String
    let sign: Character
    let flag: Character
    
    
    static let usd = Currency(type: CurrencyType.usd, name: "Доллар США", sign: "$", flag: "🇺🇲" )
    static let rub = Currency(type: CurrencyType.rub, name: "Российский рубль", sign: "₽", flag: "🇷🇺" )
    static let eur = Currency(type: CurrencyType.eur, name: "Евро", sign: "€", flag: "🇪🇺"  )
    static let byn = Currency(type: CurrencyType.byn, name: "Белорусский рубль", sign: "B", flag: "🇧🇾" )
    
    static let all = [usd, rub, eur, byn]
}


