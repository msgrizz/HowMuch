//
//  CurrencyProvider.swift
//  HowMuch
//
//  Created by Максим Казаков on 09/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import Foundation

class CurrencyProvider {
    static var shared = CurrencyProvider()
    static let ratesNotification = Notification.Name("rates")
    

    func getRate(from: CurrencyType, to: CurrencyType) -> Float {
        let fromRate = rates[from]!
        let toRate = rates[to]!
        return fromRate / toRate
    }
    
    
    

    // MARK: -Private
    static let defaultRetes: [CurrencyType : Float] = [
        .usd : 1,
        .rub : 0.01755,
        .eur: 1.19209,
        .byn: 0.50
    ]
    
    private var rates: [CurrencyType : Float] = CurrencyProvider.defaultRetes {
        didSet {
            NotificationCenter.default.post(name: CurrencyProvider.ratesNotification, object: nil)
        }
    }
    private static let currencyRatesKey = "CurrencyRates"
    
    
    private init() {
        if let rates = loadFromLocalStorage() {
            self.rates = rates
        }
        syncRates()
    }
    
    
    
    
    private func saveToLocalStorage(rates: [CurrencyType : Float]) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(rates, forKey: CurrencyProvider.currencyRatesKey)
    }
    
    
    
    private func loadFromLocalStorage() -> [CurrencyType : Float]? {
        let userDefaults = UserDefaults.standard
        guard let rates = userDefaults.dictionary(forKey: CurrencyProvider.currencyRatesKey) else {
            return nil
        }
        return parseRates(from: rates)
    }
    
    
    
    func syncRates() {
        let session = URLSession(configuration: .default)
        
        if var urlComponents = URLComponents(string: "https://api.fixer.io/latest") {
            urlComponents.query = "base=USD"
            guard let url = urlComponents.url else { return }
            
            let dataTask = session.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Sync rates network error: \(error)")
                } else if let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    
                    let newRates = self.parseRates(from: data)
                    self.rates = self.rates.merging(newRates, uniquingKeysWith: { $1 })
                }
            }
            dataTask.resume()
        }
    }
    
    
    func parseRates(from data: Data) -> [CurrencyType : Float] {
        guard let obj = try? JSONSerialization.jsonObject(with: data, options: []),
            let dict = obj as? [String: Any],
            let ratesDict = dict["rates"] as? [String: Any]
        else {
            return [:]
        }
        return parseRates(from: ratesDict)
    }
    
    
    
    func parseRates(from dict: [String: Any]) -> [CurrencyType : Float] {
        return Dictionary(uniqueKeysWithValues: dict.flatMap { key, value in
            guard let currencyType = CurrencyType(rawValue: key.lowercased()),
                let value = value as? Float
                else {
                    return nil
            }
            return (currencyType, value)
        })
    }
}
