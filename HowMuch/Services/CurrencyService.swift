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
    static private let url = URL(string: "http://www.apilayer.net/api/live?access_key=f43745fea97769eb3ae4eb20ae7a3bc6")!
    
    
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
        
        
        let dataTask = session.dataTask(with: CurrencyService.url) { data, response, error in
            if let error = error {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
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
            let ratesDict = dict["quotes"] as? [String: Any]
            else {
                return [:]
        }
        return parseRates(from: ratesDict)
    }
    
    
    
    private func parseRates(from dict: [String: Any]) -> [Currency : Float] {
        return Dictionary(uniqueKeysWithValues: dict.flatMap { key, value in
            let shortName = key.count > 3 ? String(key.suffix(from: key.index(key.startIndex, offsetBy: 3))) : key
            guard let currencyType = Currency(rawValue: shortName),
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
//         обновляем если разница больше чем в 7 дней
        guard let dayDiff = Calendar.current.dateComponents([.day], from: lastUpdate, to: Date()).day,
            dayDiff > 7
            else {
                return false
        }
        return true
    }
}
