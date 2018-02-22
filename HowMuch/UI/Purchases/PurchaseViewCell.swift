//
//  PurchaseViewCell.swift
//  HowMuch
//
//  Created by Максим Казаков on 22/02/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import UIKit

class PurchaseViewCell: UITableViewCell {
    static let identifier = String(describing: PurchaseViewCell.self)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(buyButton)
        contentView.addSubview(boughtImage)
        
        buyButton.addTarget(self, action: #selector(buyAction), for: .touchUpInside)
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(viewModel: PurchaseViewModel, onBuy: @escaping () -> Void) {
        nameLabel.text = viewModel.name
        priceLabel.text = viewModel.price
        buyButton.isHidden = viewModel.state == .notBought
        boughtImage.isHidden = viewModel.state == .bought(expired: nil)
        self.onBuy = onBuy
    }
    
    
    // MARK: Private
    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    private let buyButton = UIButton()
    private let boughtImage = UIImageView()
    private var onBuy: (() -> Void)?

    
    
    @objc private func buyAction() {
        onBuy?()
    }
    
    
    private func setupConstraints() {
        let guide = contentView.safeAreaLayoutGuide
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: guide.trailingAnchor, constant: 8),
            nameLabel.topAnchor.constraint(equalTo: guide.topAnchor, constant: 4),
        ])
        
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            priceLabel.leadingAnchor.constraint(equalTo: guide.trailingAnchor, constant: 8),
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 3),
        ])
        priceLabel.font = UIFont.systemFont(ofSize: 14)
        priceLabel.textColor = UIColor.darkGray
        
        buyButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buyButton.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -8),
            buyButton.centerYAnchor.constraint(equalTo: guide.centerYAnchor),
            buyButton.widthAnchor.constraint(equalToConstant: 24),
            buyButton.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        boughtImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            boughtImage.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -8),
            boughtImage.centerYAnchor.constraint(equalTo: guide.centerYAnchor),
            boughtImage.widthAnchor.constraint(equalToConstant: 24),
            boughtImage.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
}
