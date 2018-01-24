//
//  ConvertPanelView.swift
//  HowMuch
//
//  Created by Максим Казаков on 13/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import UIKit

protocol ConvertPanelViewDelegate: class {
    func onSwap()
}


class ConvertPanelView: UIView {
    weak var delegate: ConvertPanelViewDelegate?
    
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
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        changeButton.setImage(#imageLiteral(resourceName: "changeIcon"), for: .normal)
        changeButton.backgroundColor = UIColor.white
        changeButton.addTarget(self, action: #selector(onSwap), for: .touchUpInside)
        
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
    
    
    
    // MARK: -Private
    private let sourceView = SourceCurrencyView()
    private let resultView = ResultCurrencyView()
    private let changeButton = UIButton(type: .system)

    
    @objc private func onSwap() {
        delegate?.onSwap()
    }
    
    
    
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
