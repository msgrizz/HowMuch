//
//  SettingsViewController.swift
//  HowMuch
//
//  Created by Максим Казаков on 13/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import UIKit
import ReSwift
import StoreKit


class SettingViewController: UITableViewController {
    
    struct Props {
        struct CurrencyItem {
            let currency: Currency
            let onSelect: ((Currency) -> Void)?
        }
        let sourceCurrency: CurrencyItem
        let resultCurrency: CurrencyItem
        
        struct TryParseToFloatItem {
            let value: Bool
            let onChange: ((Bool) -> Void)?
        }
        let tryParseToFloat: TryParseToFloatItem
        
        static let zero = Props(sourceCurrency: CurrencyItem.init(currency: .USD, onSelect: nil),
                                resultCurrency: CurrencyItem(currency: .EUR, onSelect: nil),
                                tryParseToFloat: TryParseToFloatItem(value: true, onChange: nil))
    }
    
    var props: Props = .zero {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    static let identifier = String(describing: SettingViewController.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        title = "SettingsTitle".localized
        tableView.register(SelectCurrencyCellView.self, forCellReuseIdentifier: SelectCurrencyCellView.identifier)
        tableView.register(CheckRecognizeFloatViewCell.self, forCellReuseIdentifier: CheckRecognizeFloatViewCell.identifier)
        tableView.register(ButtonViewCell.self, forCellReuseIdentifier: ButtonViewCell.identifier)
        navigationItem.largeTitleDisplayMode = .always
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].description
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        switch section {
        case .recognizingSettings:
            return 1
        case .purchases:
            return 1
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        switch section {
        case .purchases:
            switch indexPath.row {
            case 0:
                openPurchases()                
            default:
                break
            }
        default:
            break
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        switch section {
        case .recognizingSettings:
            let cell = tableView.dequeueReusableCell(withIdentifier: CheckRecognizeFloatViewCell.identifier) as! CheckRecognizeFloatViewCell
            cell.setup(flag: props.tryParseToFloat.value) { isOn in
                self.props.tryParseToFloat.onChange?(isOn)
            }
            return cell
        case .purchases:
            let cell = tableView.dequeueReusableCell(withIdentifier: ButtonViewCell.identifier) as! ButtonViewCell
            cell.setup(title: "Purchase.BuyButtonTitle".localized)
            return cell
        }
    }
    
    
    
    // MARK: -Private
    enum Sections: CustomStringConvertible {
        case recognizingSettings
        case purchases
        
        var description: String {
            switch self {
            case .recognizingSettings:
                return "RecognizingSettingsTitle".localized
            case .purchases:
                return "PurchasesTitle".localized
            }
        }
    }
    
    private let sections: [Sections] = [.recognizingSettings, .purchases]
    
}



extension SettingViewController: StoreSubscriber {
    func connect(to store: Store<AppState>) {
        store.subscribe(self) { subscription in
            subscription.select { state in
                state.settings
            }
        }
    }
    
    func newState(state: SettingsState) {
        props = Props(sourceCurrency: Props.CurrencyItem(currency: state.sourceCurrency,
                                                         onSelect: { currency in
                                                            store.dispatch(SetSourceCurrencyAction(currency: currency))
        }),
                      resultCurrency: Props.CurrencyItem(currency: state.resultCurrency,
                                                         onSelect: { currency in
                                                            store.dispatch(SetResultCurrencyAction(currency: currency))
                      }),
                      tryParseToFloat: Props.TryParseToFloatItem(value: state.tryParseFloat,
                                                                 onChange: { value in
                                                                    store.dispatch(SetParseToFloatAction(value: value))
                      })
        )
    }
}


