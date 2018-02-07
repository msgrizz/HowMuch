//
//  ResultCurrencyView.swift
//  HowMuch
//
//  Created by Максим Казаков on 24/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import UIKit

protocol ResultCurrencyViewDelegate: class {
    func onTapCurrency(sender: UIView)
}

class ResultCurrencyView: UIView {
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    private var tapRecognizer: UITapGestureRecognizer!
    
    weak var delegate: ResultCurrencyViewDelegate?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        
        titleLabel.textAlignment = .center
        valueLabel.textAlignment = .center
        
        addSubview(titleLabel)
        addSubview(valueLabel)
        
        setupConstraints()
        titleLabel.font = UIFont.systemFont(ofSize: 22)
        valueLabel.font = UIFont.systemFont(ofSize: 24)
        valueLabel.adjustsFontSizeToFitWidth = true
        valueLabel.minimumScaleFactor = 0.5
        
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectCurrency))
        titleLabel.addGestureRecognizer(tapRecognizer)
        titleLabel.isUserInteractionEnabled = true
    }


    
    @objc func selectCurrency() {
        delegate?.onTapCurrency(sender: self)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(title: String) {
        titleLabel.text = String(title)
    }
    
    
    func set(value: String) {
        valueLabel.text = value
    }
    
    
    func reset() {
        valueLabel.text = "0.00"
    }
    
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),
            titleLabel.widthAnchor.constraint(equalTo: widthAnchor)
            ])
        
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            valueLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),
            valueLabel.widthAnchor.constraint(equalTo: widthAnchor)
            ])
    }
}
