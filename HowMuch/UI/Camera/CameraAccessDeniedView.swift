//
//  CameraAccessDeniedView.swift
//  HowMuch
//
//  Created by Максим Казаков on 03/02/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//


import UIKit

class CameraAccessDeniedView: UIView {
    
    static let mainText = "Разрешите доступ к камере в настройках приложения, чтобы позволить приложению распознавать цену"
    static let buttonText = "Открыть настройки"
    
    let mainLabel = UILabel()
    let settingsButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(mainLabel)
        addSubview(settingsButton)
        
        settingsButton.setTitle(CameraAccessDeniedView.buttonText, for: .normal)
        settingsButton.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        settingsButton.addTarget(self, action: #selector(openSettings), for: .touchUpInside)
        
        mainLabel.text = CameraAccessDeniedView.mainText
        mainLabel.font = UIFont.systemFont(ofSize: 18)
        mainLabel.textAlignment = .center
        mainLabel.numberOfLines = 0
        
        backgroundColor = UIColor.white
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: -Private
    
    func setupConstraints() {
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
            mainLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainLabel.bottomAnchor.constraint(equalTo: centerYAnchor)])
        
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            settingsButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
            settingsButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            settingsButton.topAnchor.constraint(equalTo: centerYAnchor, constant: 20)])
    }
    
    
    @objc func openSettings() {
        guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
            return
        }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl)
        }
    }
}
