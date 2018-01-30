//
//  SelectCurrencyCellView.swift
//  HowMuch
//
//  Created by Максим Казаков on 13/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import UIKit


class SelectCurrencyCellView: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {
    
    static let identifier = String(describing: SelectCurrencyCellView.self)
    
    let titleLabel = UILabel()
    let valueField = UITextField()
    let pickerView = UIPickerView()
    
    var onChanged: ((Currency) -> Void)?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(valueField)
        
        selectionStyle = .none
        pickerView.dataSource = self
        pickerView.delegate = self
        
        let toolBar = ToolbarReturn(tintColor: tintColor) { [weak self] in
            guard let strong = self else { return }
            strong.onEndEditing()
        }
        
        valueField.inputView = pickerView
        valueField.inputAccessoryView = toolBar
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setup(title: String, value: Currency, values: [Currency], onChanged: ((Currency) -> Void)? = nil) {
        self.values = values
        self.onChanged = onChanged
        let selectedIdx = values.index {$0 == value} ?? -1
        if selectedIdx >= 0 {
            pickerView.selectRow(selectedIdx, inComponent: 0, animated: false)
        }
        
        titleLabel.text = title
        valueField.text = value.shortName
    }
    
    
    
    func select() {
        valueField.becomeFirstResponder()
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return values.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(values[row].flag) + " " + values[row].name
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let value = values[row]
        valueField.text = value.shortName
    }
    
    
    
    
    // Mark: -Private
    private var values: [Currency]!
    
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        
        valueField.translatesAutoresizingMaskIntoConstraints = false
        valueField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        valueField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        
        pickerView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    private func onEndEditing() {
        let value = values[pickerView.selectedRow(inComponent: 0)]
        onChanged?(value)
        valueField.resignFirstResponder()
    }
}

