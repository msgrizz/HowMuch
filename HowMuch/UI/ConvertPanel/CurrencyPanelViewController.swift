//
//  ConvertPanelViewController.swift
//  HowMuch
//
//  Created by Максим Казаков on 27/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import UIKit

class ConvertPanelViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(convertPanelView)
        setupConstraints()
    }
    
    
    weak var delegate: ConvertPanelViewDelegate? {
        didSet {
            convertPanelView.delegate = delegate
        }
    }
    

    // MARK: -Private
    private let convertPanelView = ConvertPanelView()
    
    private func setupConstraints() {
        let guide = view.safeAreaLayoutGuide
        
        convertPanelView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            convertPanelView.widthAnchor.constraint(equalTo: guide.widthAnchor, constant: 0),
            convertPanelView.heightAnchor.constraint(equalTo: guide.heightAnchor, constant: 0),
            convertPanelView.centerXAnchor.constraint(equalTo: guide.centerXAnchor, constant: 0),
            convertPanelView.centerYAnchor.constraint(equalTo: guide.centerYAnchor, constant: 0),
            ])
    }
    
    
    func set(settings: Settings) {
        convertPanelView.reset()
        convertPanelView.setupCurrencies(fromCurrency: settings.sourceCurrency, toCurrency: settings.resultCurrency)
    }
}
