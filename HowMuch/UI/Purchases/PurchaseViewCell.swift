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
        contentView.addSubview(expiresLabel)
        contentView.addSubview(buyButton)
        contentView.addSubview(boughtImage)
        contentView.addSubview(activityIndicator)
        
        buyButton.setTitle("BuyButton.Title".localized, for: .normal)
        buyButton.clipsToBounds = true
        buyButton.layer.cornerRadius = 5
        buyButton.layer.borderColor = Colors.accent1.cgColor
        buyButton.layer.borderWidth = 1
        buyButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        activityIndicator.hidesWhenStopped = true
        nameLabel.numberOfLines = 0
        
        buyButton.addTarget(self, action: #selector(buyAction), for: .touchUpInside)
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(viewModel: ProductViewModel, onBuy: @escaping () -> Void) {
        nameLabel.text = viewModel.name
        priceLabel.text = viewModel.price
        switch viewModel.type {
        case .subscription(let term):
            if case .bought(let date) = viewModel.state {
                let dayDiff = Calendar.current.dateComponents([.day], from: date, to: Date()).day ?? 0
                let expiredThrough = term - dayDiff
                expiresLabel.text = "Days left: \(expiredThrough)"
            }
        default:
            expiresLabel.text = ""
        }
        
        buyButton.isHidden = true
        boughtImage.isHidden = true
        activityIndicator.stopAnimating()
        
        switch viewModel.state {
        case .bought(let _):
            boughtImage.isHidden = false
            // expired text
        case .inProcess:
            activityIndicator.startAnimating()
        case .notBought:
            buyButton.isHidden = false
        case .disabled:
            break
        }
        self.onBuy = onBuy
    }
    
    
    // MARK: Private
    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    private let expiresLabel = UILabel()
    private let buyButton = UIButton(type: .system)
    private let boughtImage = UIImageView(image: #imageLiteral(resourceName: "checkedIcon"))
    private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    private var onBuy: (() -> Void)?

    
    
    @objc private func buyAction() {
        onBuy?()
    }
    
    
    private func setupConstraints() {
        let guide = contentView.safeAreaLayoutGuide
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: buyButton.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: guide.topAnchor, constant: 6),
        ])
        
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            priceLabel.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 12),
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 3),
            priceLabel.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -6),
        ])
        priceLabel.font = UIFont.systemFont(ofSize: 14)
        priceLabel.textColor = UIColor.darkGray
        
        expiresLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            expiresLabel.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 12),
            expiresLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 3),
        ])
        expiresLabel.font = UIFont.systemFont(ofSize: 14)
        expiresLabel.textColor = UIColor.darkGray
        
        buyButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buyButton.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -12),
            buyButton.centerYAnchor.constraint(equalTo: guide.centerYAnchor),
        ])
        buyButton.setContentCompressionResistancePriority(UILayoutPriority(751), for: .horizontal)

        boughtImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            boughtImage.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -12),
            boughtImage.centerYAnchor.constraint(equalTo: guide.centerYAnchor),
            boughtImage.widthAnchor.constraint(equalToConstant: 24),
            boughtImage.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -12),
            activityIndicator.centerYAnchor.constraint(equalTo: guide.centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 35),
            activityIndicator.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
}
