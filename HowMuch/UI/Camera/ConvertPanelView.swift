//
//  ConvertPanelView.swift
//  HowMuch
//
//  Created by Максим Казаков on 13/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import UIKit

class CurrencyView: UIView {
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        
        titleLabel.textAlignment = .center
        valueLabel.textAlignment = .center
        
        addSubview(titleLabel)
        addSubview(valueLabel)
        
        setupConstraints()
        titleLabel.font = UIFont.systemFont(ofSize: 22)
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


class ConvertPanelView: UIView {
    private let sourceView = CurrencyView()
    private let resultView = CurrencyView()
    private let changeButton = UIButton(type: .system)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        changeButton.setImage(#imageLiteral(resourceName: "changeIcon"), for: .normal)
        changeButton.backgroundColor = UIColor.white
        
        addSubview(sourceView)
        addSubview(resultView)
        addSubview(changeButton)
        
        backgroundColor = UIColor.white
        setupValues(from: 0, to: 0)
        
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupCurrencies(fromCurrency: Currency, toCurrency: Currency) {
        sourceView.set(title: "\(fromCurrency.flag) \(fromCurrency.shortName)")
        resultView.set(title: "\(toCurrency.flag) \(toCurrency.shortName)")
    }
    
    
    func reset() {
        setupValues(from: 0.0, to: 0.0)
    }
    
    
    
    func setupValues(from: Float, to: Float) {
        sourceView.set(value: String(format: "%.2f", from))
        resultView.set(value: String(format: "%.2f", to))
    }
    
    
    // MARK: -Private
    
    private func setupConstraints() {
        sourceView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sourceView.leadingAnchor.constraint(equalTo: leadingAnchor),
            sourceView.topAnchor.constraint(equalTo: topAnchor),
            sourceView.heightAnchor.constraint(equalTo: heightAnchor),
            sourceView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4)
            ])
        
        changeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            changeButton.topAnchor.constraint(equalTo: topAnchor),
            changeButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            changeButton.heightAnchor.constraint(equalTo: heightAnchor),
            changeButton.widthAnchor.constraint(equalToConstant: 35)
        ])
        
        resultView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            resultView.trailingAnchor.constraint(equalTo: trailingAnchor),
            resultView.topAnchor.constraint(equalTo: topAnchor),
            resultView.heightAnchor.constraint(equalTo: heightAnchor),
            resultView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4)
            ])
    }
}
