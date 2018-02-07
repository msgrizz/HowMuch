//
//  CurrencyViewCell.swift
//  HowMuch
//
//  Created by Максим Казаков on 07/02/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import UIKit


class CurrencyViewCell: UITableViewCell {
    static let identifier = String(describing: CurrencyViewCell.self)
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        checkedView.isHidden = !selected
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(nameLabel)
        contentView.addSubview(flagLabel)
        contentView.addSubview(rateLabel)
        contentView.addSubview(checkedView)
        
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setup(currency: CurrencyItem) {
        nameLabel.text = "\(currency.currency.shortName) - \(currency.currency.name)"
        flagLabel.text = currency.currency.flag
        let usdRate = 1 / currency.rate
        rateLabel.text = "1 \(currency.currency.shortName) = \(String(format: "%6f", usdRate)) USD"
    }
    
    
    //MARK: -Private
    
    private let nameLabel = UILabel()
    private let flagLabel = UILabel()
    private let rateLabel = UILabel()
    private let checkedView = UIImageView(image: #imageLiteral(resourceName: "checkedIcon"))
    
    
    private func setupConstraints() {
        let guide = contentView.safeAreaLayoutGuide

        flagLabel.translatesAutoresizingMaskIntoConstraints = false
        flagLabel.font = UIFont.systemFont(ofSize: 36)
        
        NSLayoutConstraint.activate([
            flagLabel.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 8),
            flagLabel.centerYAnchor.constraint(equalTo: guide.centerYAnchor)
        ])
        flagLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: flagLabel.trailingAnchor, constant: 8),
            nameLabel.topAnchor.constraint(equalTo: guide.topAnchor, constant: 4),
            nameLabel.trailingAnchor.constraint(equalTo: checkedView.leadingAnchor, constant: -8)
        ])
        
        rateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rateLabel.leadingAnchor.constraint(equalTo: flagLabel.trailingAnchor, constant: 8),
            rateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 3),
            rateLabel.trailingAnchor.constraint(equalTo: checkedView.leadingAnchor, constant: -8)
        ])
        rateLabel.font = UIFont.systemFont(ofSize: 14)
        rateLabel.textColor = UIColor.darkGray
        
        checkedView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            checkedView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -8),
            checkedView.centerYAnchor.constraint(equalTo: guide.centerYAnchor),
            checkedView.widthAnchor.constraint(equalToConstant: 24),
            checkedView.heightAnchor.constraint(equalToConstant: 24)
            ])        
    }
}
