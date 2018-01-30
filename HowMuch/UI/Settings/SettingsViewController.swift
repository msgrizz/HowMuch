//
//  SettingsViewController.swift
//  HowMuch
//
//  Created by Максим Казаков on 13/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import UIKit
import ReSwift


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
        
        static let zero = Props(sourceCurrency: CurrencyItem.init(currency: .usd, onSelect: nil),
                                resultCurrency: CurrencyItem(currency: .usd, onSelect: nil),
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
        title = "Настройки"        
        tableView.register(SelectCurrencyCellView.self, forCellReuseIdentifier: SelectCurrencyCellView.identifier)
        tableView.register(CheckRecognizeFloatViewCell.self, forCellReuseIdentifier: CheckRecognizeFloatViewCell.identifier)
    }
    
    private let sections = ["Выбор валюты", "Настройки распознавания"]
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 1
        default:
            fatalError()
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cellView = tableView.cellForRow(at: indexPath) as? SelectCurrencyCellView {
            cellView.select()
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: SelectCurrencyCellView.identifier) as! SelectCurrencyCellView
                cell.setup(title: "Конвертировать из", value: props.sourceCurrency.currency, values: Currency.all) { currency in
                    self.props.sourceCurrency.onSelect?(currency)
                }
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: SelectCurrencyCellView.identifier) as! SelectCurrencyCellView
                cell.setup(title: "Конвертировать в", value: props.resultCurrency.currency, values: Currency.all) { currency in
                    self.props.resultCurrency.onSelect?(currency)
                }
                return cell
            default:
                fatalError()
            }
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: CheckRecognizeFloatViewCell.identifier) as! CheckRecognizeFloatViewCell
            cell.setup(flag: props.tryParseToFloat.value) { isOn in
                self.props.tryParseToFloat.onChange?(isOn)
            }
            return cell
        default:
            fatalError()
        }
    }
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


