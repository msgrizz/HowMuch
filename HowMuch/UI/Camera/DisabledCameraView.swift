//
//  DisabledCameraView.swift
//  HowMuch
//
//  Created by Максим Казаков on 24/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import UIKit

class DisabledCameraView: UIView {
    
    static let messageText = "Нажмите, чтобы продолжить"
    let messageLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(messageLabel)
        messageLabel.font = UIFont.systemFont(ofSize: 24)
        messageLabel.text = DisabledCameraView.messageText
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0        
        backgroundColor = UIColor.white.withAlphaComponent(0.5)
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: -Private
    
    func setupConstraints() {
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messageLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7),
            messageLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7),
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor)])
    }

}
