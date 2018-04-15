//
//  ConvertPanelViewController.swift
//  HowMuch
//
//  Created by Максим Казаков on 27/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import UIKit
import ReSwift

class ConvertPanelViewController: UIViewController, SourceCurrencyViewDelegate, ResultCurrencyViewDelegate {
    
    struct Props {
        let manualEditingMode: Bool
        let sourceCurrency: Currency
        let resultCurrency: Currency
        let sourceValue: Float
        let resultValue: Float
        
        let onChange: ((Float) -> Void)?
        let onBeginEditing: (() -> Void)?
        let onStopEditing: (() -> Void)?
        
        static let zero = Props(manualEditingMode: false, sourceCurrency: Currency.USD, resultCurrency: Currency.USD,
                                sourceValue: 0.0, resultValue: 0.0, onChange: nil, onBeginEditing: nil, onStopEditing: nil)
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
        convertPanelView.sourceViewDelegate = self
        convertPanelView.resultViewDelegate = self
        setupConstraints()
    }
    
    // MARK: -ResultCurrencyViewDelegate
    func onTapResultCurrencyView() {
        openSelectCurrencyVC(isSource: false)
    }

    
    
    // MARK: -SourceCurrencyViewDelegate
    func onTapSourceCurrencyView() {
        openSelectCurrencyVC()
    }
    
    
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
            convertPanelView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            convertPanelView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            convertPanelView.topAnchor.constraint(equalTo: guide.topAnchor),
            convertPanelView.bottomAnchor.constraint(equalTo: guide.bottomAnchor)
            ])
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
