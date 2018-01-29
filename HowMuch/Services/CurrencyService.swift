//
//  CurrencyService.swift
//  HowMuch
//
//  Created by Максим Казаков on 09/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import UIKit

public class CurrencyService {
    static var shared = CurrencyService()
    static let ratesNotification = Notification.Name("rates")
    

    func loadFromLocalStorage() -> [Currency : Float]? {
        let userDefaults = UserDefaults.standard
        guard let rates = userDefaults.dictionary(forKey: CurrencyService.currencyRatesKey) else {
            return nil
        }
        return parseRates(from: rates)
    }

    
    func updateIfNeeded(onUpdated: @escaping ([Currency : Float]) -> Void) {
        guard isNeedUpdate() else { return }
        guard !updateInProcess else { return }
        updateInProcess = true
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
                    DispatchQueue.main.async {
                        self.updateInProcess = false
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        let newRates = self.parseRates(from: data)
                        onUpdated(newRates)
                    }
                }
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            dataTask.resume()
        }
    }
    
    
    
    func saveToLocalStorage(rates: [Currency : Float]) {
        let userDefaults = UserDefaults.standard
        let plistRates: [String: Float] = Dictionary(uniqueKeysWithValues: rates.flatMap { key, value in
            return (key.rawValue, value)
        })
        userDefaults.set(plistRates, forKey: CurrencyService.currencyRatesKey)
        userDefaults.set(CurrencyService.dateFormatter.string(from: Date()), forKey: CurrencyService.lastUpdateKey)
    }
    

    // MARK: -Private

    
    private static let currencyRatesKey = "CurrencyRates"
    private static let lastUpdateKey = "LastUpdate"
    
    private var updateInProcess = false
    
    
    
    
    private func parseRates(from data: Data) -> [Currency : Float] {
        guard let obj = try? JSONSerialization.jsonObject(with: data, options: []),
            let dict = obj as? [String: Any],
            let ratesDict = dict["rates"] as? [String: Any]
        else {
            return [:]
        }
        return parseRates(from: ratesDict)
    }
    
    
    
    private func parseRates(from dict: [String: Any]) -> [Currency : Float] {
        return Dictionary(uniqueKeysWithValues: dict.flatMap { key, value in
            guard let currencyType = Currency(rawValue: key),
                let float = value as? Float
                else {
                    return nil
            }
            return (currencyType, float)
        })
    }
    
    
    
    private static let dateFormatter: DateFormatter = {
       let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter
    }()
    
    
    
    private func isNeedUpdate() -> Bool {
        guard let lastUpdateString = UserDefaults.standard.string(forKey: CurrencyService.lastUpdateKey),
            let lastUpdate = CurrencyService.dateFormatter.date(from: lastUpdateString) else {
            return true
        }

        // обновляем если разница больше чем в 1 день
        guard let dayDiff = Calendar.current.dateComponents([.day], from: lastUpdate, to: Date()).day,
            dayDiff > 1
        else {
            return false
        }
        return true
    }
}
