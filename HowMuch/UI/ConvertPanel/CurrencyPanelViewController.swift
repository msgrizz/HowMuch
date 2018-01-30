//
//  ConvertPanelViewController.swift
//  HowMuch
//
//  Created by Максим Казаков on 27/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import UIKit
import ReSwift

class ConvertPanelViewController: UIViewController, ConvertPanelViewDelegate {
    
    struct Props {
        let sourceCurrency: Currency
        let resultCurrency: Currency
        let sourceValue: Float
        let resultValue: Float
        let onSwap: (() -> Void)?
        let onChange: ((Float) -> Void)?
        
        static let zero = Props(sourceCurrency: Currency.usd, resultCurrency: Currency.usd,
                                sourceValue: 0.0, resultValue: 0.0, onSwap: nil, onChange: nil)
    }
    
    
    var props: Props = .zero {
        didSet {
            convertPanelView.setupCurrencies(fromCurrency: props.sourceCurrency, toCurrency: props.resultCurrency)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(convertPanelView)
        convertPanelView.delegate = self
        setupConstraints()
    }
    
    
    
    // MARK: -ConvertPanelViewDelegate
    func onSwap() {
        props.onSwap?()
    }
    
    
    func onChanged(value: String) {
        props.onChange?(value.float)
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
}



extension ConvertPanelViewController: StoreSubscriber {
    func connect(to store: Store<AppState>) {
        store.subscribe(self)
    }
    
    func newState(state: AppState) {
        let settings = state.settings.settings
        props = Props(sourceCurrency: settings.sourceCurrency,
                      resultCurrency: settings.sourceCurrency,
                      sourceValue: state.recognizing.sourceValue,
                      resultValue: state.recognizing.resultValue,
                      onSwap: {
                        store.dispatch(SetSourceCurrencyAction(currency: self.props.resultCurrency))
                        store.dispatch(SetResultCurrencyAction(currency: self.props.sourceCurrency))
        },
                      onChange: { value in
                        store.dispatch(CreateSetValuesAction(state: state, source: value))
        })
    }
}
