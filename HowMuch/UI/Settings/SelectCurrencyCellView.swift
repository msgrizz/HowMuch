//
//  SelectCurrencyCellView.swift
//  HowMuch
//
//  Created by Максим Казаков on 13/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import UIKit

class SelectCurrencyCellView: UITableViewCell {
    
    static let identifier = String(describing: SelectCurrencyCellView.self)
    
    let titleLabel = UILabel()
    let valueField = UITextField()
    let pickerView = UIPickerView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(valueField)
        contentView.addSubview(pickerView)
        
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        
        valueField.translatesAutoresizingMaskIntoConstraints = false
        valueField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        valueField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        
        pickerView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func setup(title: String, values: [String]) {
        titleLabel.text = title
        valueField.text = "hello"
    }
}

