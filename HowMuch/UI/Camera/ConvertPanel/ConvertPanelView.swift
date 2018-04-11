//
//  ConvertPanelView.swift
//  HowMuch
//
//  Created by Максим Казаков on 13/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import UIKit
import MMNumberKeyboard


protocol SourceCurrencyViewDelegate: class {
    func onChanged(value: String)
    func onBeginEditing()
    func onStopEditing()
    func onTapSourceCurrencyView()
}



protocol ResultCurrencyViewDelegate: class {
    func onTapResultCurrencyView()
}



class ConvertPanelView: UIView {
    
    static let height = CGFloat(100)
    static let width = CGFloat(180)
    
    weak var sourceViewDelegate: SourceCurrencyViewDelegate?
    weak var resultViewDelegate: ResultCurrencyViewDelegate?
    
    
    func setupCurrencies(fromCurrency: Currency, toCurrency: Currency) {
        sourceFlag.text = fromCurrency.flag
        sourceCurrencyName.text = fromCurrency.shortName
        
        resultFlag.text = toCurrency.flag
        resultCurrencyName.text = toCurrency.shortName
    }
    
    
    
    func reset() {
        sourcePrice.text = ""
        sourcePrice.placeholder = "0.00"
        resultPrice.text = "0.00"
    }
    
    
    
    func setupValues(from: Float, to: Float) {
        sourcePrice.text = from > 0.0 ? String(format: "%.2f", from) : ""
        resultPrice.text = String(format: "%.2f", to)
    }
    
    
    func set(result: Float) {
        resultPrice.text = String(format: "%.2f", result)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        fatalError("init(coder:) has not been implemented")
    }

    
    @IBAction func onTapResultCurrency(_ sender: Any) {
        resultViewDelegate?.onTapResultCurrencyView()
    }
    
    
    @IBAction func onTapSourceCurrency(_ sender: Any) {
        sourceViewDelegate?.onTapSourceCurrencyView()
    }
    
    
    // MARK: -Private
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var sourcePrice: UITextField!
    @IBOutlet weak var resultPrice: UILabel!
    @IBOutlet weak var sourceFlag: UILabel!
    @IBOutlet weak var sourceCurrencyName: UILabel!
    @IBOutlet weak var resultFlag: UILabel!
    @IBOutlet weak var resultCurrencyName: UILabel!
    
    
    
    private func commonInit() {
        Bundle.main.loadNibNamed("ConvertPanel", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        reset()
        
        resultPrice.adjustsFontSizeToFitWidth = true
        resultPrice.minimumScaleFactor = 0.5
        
        let keyboard = MMNumberKeyboard()
        keyboard.allowsDecimalPoint = true
        keyboard.returnKeyTitle = "DoneButtonTitle".localized
        sourcePrice.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        sourcePrice.inputView = keyboard
        
        sourcePrice.adjustsFontSizeToFitWidth = true
        sourcePrice.minimumFontSize = 0.5
        sourcePrice.delegate = self
        
        clipsToBounds = true
        layer.cornerRadius = 5
    }
}



extension ConvertPanelView: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        sourceViewDelegate?.onBeginEditing()
        return true
    }
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        sourceViewDelegate?.onStopEditing()
        return true
    }
    
    
    @objc func textFieldDidChange(textField: UITextField) {
        sourceViewDelegate?.onChanged(value: textField.text ?? "")
    }
}
