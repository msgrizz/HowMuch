//
//  SourceCurrencyView.swift
//  HowMuch
//
//  Created by Максим Казаков on 24/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import UIKit


class SourceCurrencyView: UIView {
    private let titleLabel = UILabel()
    private let valueTextField = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        
        titleLabel.textAlignment = .center
        valueTextField.textAlignment = .center
        
        addSubview(titleLabel)
        addSubview(valueTextField)
        
        setupConstraints()
        titleLabel.font = UIFont.systemFont(ofSize: 22)
        valueTextField.font = UIFont.systemFont(ofSize: 24)
        valueTextField.backgroundColor = "DDDDDD".color
        valueTextField.layer.cornerRadius = 5
        valueTextField.clipsToBounds = true
        valueTextField.adjustsFontSizeToFitWidth = true
        valueTextField.minimumFontSize = 0.5
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(title: String) {
        titleLabel.text = String(title)
    }
    
    
    func set(value: String) {
        valueTextField.text = value
    }
    
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),
            titleLabel.widthAnchor.constraint(equalTo: widthAnchor)
            ])
        
        valueTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            valueTextField.leadingAnchor.constraint(equalTo: leadingAnchor),
            valueTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            valueTextField.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),
            valueTextField.widthAnchor.constraint(equalTo: widthAnchor)
            ])
    }
}
