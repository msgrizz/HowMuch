//
//  CheckRecognizeFloatViewCell.swift
//  HowMuch
//
//  Created by Максим Казаков on 13/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import UIKit


class CheckRecognizeFloatViewCell: UITableViewCell {
    
    static let identifier = String(describing: CheckRecognizeFloatViewCell.self)
    
    let titleLabel = UILabel()
    let switchView = UISwitch()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel.text = "Распознавать дробную часть"
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(switchView)
        
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        
        switchView.translatesAutoresizingMaskIntoConstraints = false
        switchView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        switchView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
    }
    
    
    func setup() {
//        titleLabel.text = title
//        valueField.text = "hello"
    }
}

