//
//  ConvertPanelView.swift
//  HowMuch
//
//  Created by Максим Казаков on 13/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import UIKit

class ConvertPanelView: UIView {
    private let sourceValueLabel = UILabel()
    private let resultValueLabel = UILabel()
    private let sourceCurrencyLabel = UILabel()
    private let resultCurrencyLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(sourceValueLabel)
        addSubview(resultValueLabel)
        addSubview(sourceCurrencyLabel)
        addSubview(resultCurrencyLabel)
        
        setupValues(from: 0, to: 0)
        
        //        sourceCurrencyLabel.layer.backgroundColor = UIColor.black.cgColor
        //        sourceValueLabel.layer.backgroundColor = UIColor.red.cgColor
        //        resultCurrenctLabel.layer.backgroundColor = UIColor.brown.cgColor
        //        resultValueLabel.layer.backgroundColor = UIColor.green.cgColor
        
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupCurrencies(fromCurrency: Character, toCurrency: Character) {
        sourceCurrencyLabel.text = String(fromCurrency)
        resultCurrencyLabel.text = String(toCurrency)
    }
    
    
    func setupValues(from: Float, to: Float) {
        sourceValueLabel.text = String(format: "%.2f", from)
        resultValueLabel.text = String(format: "%.2f", to)
    }
    
    
    // MARK: -Private
    
    private func setupConstraints() {
        sourceCurrencyLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sourceCurrencyLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            sourceCurrencyLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            sourceCurrencyLabel.heightAnchor.constraint(equalTo: heightAnchor),
            sourceCurrencyLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.1)
            ])
        
        sourceValueLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sourceValueLabel.leadingAnchor.constraint(equalTo: sourceCurrencyLabel.trailingAnchor),
            sourceValueLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            sourceValueLabel.heightAnchor.constraint(equalTo: heightAnchor),
            sourceValueLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4)
            ])
        
        resultCurrencyLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            resultCurrencyLabel.leadingAnchor.constraint(equalTo: sourceValueLabel.trailingAnchor),
            resultCurrencyLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            resultCurrencyLabel.heightAnchor.constraint(equalTo: heightAnchor),
            resultCurrencyLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.1)
            ])
        
        
        resultValueLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            resultValueLabel.leadingAnchor.constraint(equalTo: resultCurrencyLabel.trailingAnchor),
            resultValueLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            resultValueLabel.heightAnchor.constraint(equalTo: heightAnchor),
            resultValueLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4)
            ])
    }
}
