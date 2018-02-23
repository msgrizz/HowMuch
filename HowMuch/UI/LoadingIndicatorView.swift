//
//  LoadingIndicatorView.swift
//  HowMuch
//
//  Created by Максим Казаков on 23/02/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import UIKit

class LoadingIndicatorView: UIView {
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
        
        strLabel.text = "Loading..."
        strLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        strLabel.textColor = UIColor.white
        
        activityIndicator.frame.size = CGSize(width: 50, height: 50)
        activityIndicator.center = bounds.center
        activityIndicator.startAnimating()
        
        layer.cornerRadius = 15
        layer.masksToBounds = true
        
        addSubview(activityIndicator)
        addSubview(strLabel)
        backgroundColor = UIColor.darkGray.withAlphaComponent(0.9)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private let strLabel = UILabel(frame: CGRect.zero)
    private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
}
