//
//  ConvertPanelViewController.swift
//  HowMuch
//
//  Created by Максим Казаков on 27/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import UIKit
import ReSwift

class ConvertPanelViewController: UIViewController, ConvertPanelViewDelegate, SourceCurrencyViewDelegate, ResultCurrencyViewDelegate {
    
    struct Props {
        let manualEditingMode: Bool
        let sourceCurrency: Currency
        let resultCurrency: Currency
        let sourceValue: Float
        let resultValue: Float
        
        let onSwap: (() -> Void)?
        let onChange: ((Float) -> Void)?
        let onBeginEditing: (() -> Void)?
        let onStopEditing: (() -> Void)?
        
        static let zero = Props(manualEditingMode: false, sourceCurrency: Currency.USD, resultCurrency: Currency.USD,
                                sourceValue: 0.0, resultValue: 0.0, onSwap: nil, onChange: nil, onBeginEditing: nil, onStopEditing: nil)
    }
    
    
    var props: Props = .zero {
        didSet {
            convertPanelView.setupCurrencies(fromCurrency: props.sourceCurrency, toCurrency: props.resultCurrency)
            props.manualEditingMode ? convertPanelView.set(result: props.resultValue) : convertPanelView.setupValues(from: props.sourceValue, to: props.resultValue)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(convertPanelView)
        convertPanelView.delegate = self
        convertPanelView.sourceViewDelegate = self
        convertPanelView.resultViewDelegate = self
        setupConstraints()
    }
    
    // MARK: -ResultCurrencyViewDelegate
    func onTapCurrency(sender: UIView) {
        switch sender {
        case is ResultCurrencyView:
            openSelectCurrencyVC(isSource: false)
        case is SourceCurrencyView:
            openSelectCurrencyVC()
        default:
            return
        }
    }
    
    // MARK: -ConvertPanelViewDelegate
    func onSwap() {
        props.onSwap?()
    }
    
    
    // MARK: -SourceCurrencyViewDelegate
    func onChanged(value: String) {
        props.onChange?(value.float)
    }
    
    
    func onBeginEditing() {
        props.onBeginEditing?()
    }
    
    
    func onStopEditing() {
        props.onStopEditing?()
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
    
    
    private func openSelectCurrencyVC(isSource: Bool = true) {
        let selectVC = SelectCurrencyViewController()
        selectVC.connect(select: { $0 },
                         isChanged: { old, new in
                            return (old.currencyRates != new.currencyRates)
                                || (old.settings != new.settings)
                                || (!isSource && old.purchaseState != new.purchaseState)
        },
                         onChanged: { vc, state in
                            let rates = state.currencyRates.rates
                            let settings = state.settings
                            let selected = isSource ? settings.sourceCurrency : settings.resultCurrency
                            let isPurchased = state.purchaseState.isPurchased
                            
                            let allCurrencies = !(isPurchased || isSource) ? [Currency.USD] : Currency.allCurrencies
                            vc.props = SelectCurrencyViewController.Props(items: allCurrencies.map { currency in
                                CurrencyItem(currency: currency, rate: rates[currency] ?? 0.0,
                                             onSelect: {
                                                let action: Action = isSource ? SetSourceCurrencyAction(currency: currency) : SetResultCurrencyAction(currency: currency)
                                                store.dispatch(action)
                                })
                            }, selected: selected,
                               isSourceCurrency: isSource,
                               isPurchased: isPurchased)
        })
        navigationController?.pushViewController(selectVC, animated: true)
    }
}



extension ConvertPanelViewController: StoreSubscriber {
    func connect(to store: Store<AppState>) {
        store.subscribe(self)
    }
    
    func newState(state: AppState) {
        let settings = state.settings
        props = Props(manualEditingMode: state.recognizing.isManuallyEditing, sourceCurrency: settings.sourceCurrency,
                      resultCurrency: settings.resultCurrency,
                      sourceValue: state.recognizing.sourceValue,
                      resultValue: state.recognizing.resultValue,
                      onSwap: {
                        let src = self.props.resultCurrency
                        let res = self.props.sourceCurrency
                        store.dispatch(SetSourceCurrencyAction(currency: src))
                        store.dispatch(SetResultCurrencyAction(currency: res))
        },
                      onChange: { value in
                        store.dispatch(CreateSetValuesAction(state: state, source: value))
        },
                      onBeginEditing: {
                        store.dispatch(SetIsManualEdtitingAction(value: true))
        },
                      onStopEditing: {
                        store.dispatch(SetIsManualEdtitingAction(value: false))
        })
    }
}
