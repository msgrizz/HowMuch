//
//  SettingsViewController.swift
//  HowMuch
//
//  Created by Максим Казаков on 13/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import UIKit


class SettingViewController: UITableViewController {
    static let identifier = String(describing: SettingViewController.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Настройки"
        tableView.register(SelectCurrencyCellView.self, forCellReuseIdentifier: SelectCurrencyCellView.identifier)
        tableView.register(CheckRecognizeFloatViewCell.self, forCellReuseIdentifier: CheckRecognizeFloatViewCell.identifier)
    }
    
    private let sections = ["Выбор валюты", "Настройки распознавания"]
    
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
    

    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: SelectCurrencyCellView.identifier) as! SelectCurrencyCellView
                cell.setup(title: "Конвертировать из", values: [])
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: SelectCurrencyCellView.identifier) as! SelectCurrencyCellView
                cell.setup(title: "Конвертировать в", values: [])
                return cell
            default:
                fatalError()
            }
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: CheckRecognizeFloatViewCell.identifier) as! CheckRecognizeFloatViewCell
//            cell.setup(title: "Конвертировать в", values: [])
            return cell
        default:
            fatalError()
        }
    }
        
}


