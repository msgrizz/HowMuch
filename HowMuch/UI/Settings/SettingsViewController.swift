//
//  SettingsViewController.swift
//  HowMuch
//
//  Created by Максим Казаков on 13/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import UIKit


class SettingViewController: UITableViewController, SettingsView {
    
    static let identifier = String(describing: SettingViewController.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        title = "Настройки"        
        tableView.register(SelectCurrencyCellView.self, forCellReuseIdentifier: SelectCurrencyCellView.identifier)
        tableView.register(CheckRecognizeFloatViewCell.self, forCellReuseIdentifier: CheckRecognizeFloatViewCell.identifier)
        
        presenter = SettingsPresenter(view: self)
        presenter.fetch()
    }
    
    private let sections = ["Выбор валюты", "Настройки распознавания"]

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter.save(settings: settings)
    }
    
    
    
    //MARK: -SettingsView
    func set(settings: Settings) {
        self.settings = settings
        tableView.reloadData()
    }
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
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
        if let cell = tableView.cellForRow(at: indexPath) as? SelectCurrencyCellView {
            cell.select()
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: SelectCurrencyCellView.identifier) as! SelectCurrencyCellView
                cell.setup(title: "Конвертировать из", value: settings.sourceCurrency, values: Currency.all) { currency in
                    self.settings.sourceCurrency = currency
                }
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: SelectCurrencyCellView.identifier) as! SelectCurrencyCellView
                cell.setup(title: "Конвертировать в", value: settings.resultCurrency, values: Currency.all) { currency in
                    self.settings.resultCurrency = currency
                }
                return cell
            default:
                fatalError()
            }
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: CheckRecognizeFloatViewCell.identifier) as! CheckRecognizeFloatViewCell
            cell.setup(flag: settings.tryParseFloat) { isOn in
                self.settings.tryParseFloat = isOn
            }
            return cell
        default:
            fatalError()
        }
    }
    
    
    
    // MARK: Private
    
    private var presenter: SettingsPresenter!
    private var settings = Settings()
}


