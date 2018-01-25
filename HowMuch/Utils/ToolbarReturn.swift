//
//  ToolbarReturn.swift
//  HowMuch
//
//  Created by Максим Казаков on 25/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import UIKit

class ToolbarReturn: UIToolbar {
    
    let onReturnCallback: () -> Void
    
    @objc func onReturn() {
        onReturnCallback()
    }
    
    init(tintColor: UIColor, onReturn: @escaping () -> Void) {
        self.onReturnCallback = onReturn
        super.init(frame: CGRect.zero)
        
        barStyle = UIBarStyle.default
        isTranslucent = true
        self.tintColor = tintColor
        self.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Готово", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ToolbarReturn.onReturn))
        let flexible = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        self.setItems([flexible, doneButton], animated: false)
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

