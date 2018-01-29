//
//  CurrenciesModel.swift
//  HowMuch
//
//  Created by Максим Казаков on 08/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import Foundation


struct Currency: Hashable, RawRepresentable {
    
    let shortName: String
    let name: String
    let sign: Character
    let flag: Character
    
    init(shortName: String, name: String, sign: Character, flag: Character ) {
        self.shortName = shortName
        self.name = name
        self.sign = sign
        self.flag = flag
    }
    static let usd = Currency(shortName: "USD", name: "Доллар США", sign: "$", flag: "🇺🇲" )
    static let rub = Currency(shortName: "RUB", name: "Российский рубль", sign: "₽", flag: "🇷🇺" )
    static let eur = Currency(shortName: "EUR", name: "Евро", sign: "€", flag: "🇪🇺"  )
    static let byn = Currency(shortName: "BYN", name: "Белорусский рубль", sign: "B", flag: "🇧🇾" )
    
    static let all = [usd, rub, eur, byn]
    
    public static func ==(lhs: Currency, rhs: Currency) -> Bool {
        return lhs.shortName == rhs.shortName
    }
    
    var hashValue: Int {
        return shortName.hashValue
    }
    
    init?(rawValue: String) {
        guard let currency = Currency.mapNameToCurrency[rawValue] else {
            return nil
        }
        self = currency
    }
    
    var rawValue: String {
        return shortName
    }
    
    static private let mapNameToCurrency: [String : Currency] = [
        "USD" : .usd,
        "RUB" : .rub,
        "EUR" : .eur,
        "BYN" : .byn
    ]
}


