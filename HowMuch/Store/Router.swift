//
//  Router.swift
//  HowMuch
//
//  Created by Максим Казаков on 24/02/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import ReSwift
import UIKit
import StoreKit

extension UIViewController {
    
    func openPurchases() {
        let vc = PurchasesViewController(style: .grouped)
        navigationController?.pushViewController(vc, animated: true)
        vc.connect(select: { $0.purchaseState },
                   isChanged: { $0 != $1 },
                   onChanged: { vc, state in
                    
                    let viewModelCreator: ((SKProduct, ProductInfo) -> ProductViewModel) = { product, info in
                        var paidUpState: ProductState = .notBought
                        if product == state.productInProcess {
                            paidUpState = .inProcess
                        } else if let purchaseInfo = state.purchasedProducts.first(where: { $0.identifier ==  product.productIdentifier }) {
                            paidUpState = .bought(date: purchaseInfo.date)
                        }
                        return ProductViewModel(name: product.localizedDescription, price: "\(product.price) \(product.priceLocale.currencySymbol ?? "")", type: info.type, state: paidUpState, onBuy: {
                            store.dispatch(BuyProductAction(product: product))
                        })
                    }
                    
                    vc.props = PurchasesViewController.Props(
                        products: state.products.flatMap { product in
                            guard let info = Products.getInfoBy(identifier: product.productIdentifier) else { return nil }
                            let viewModel = viewModelCreator(product, info)
                            return viewModel
                        },
                        isLoading: state.isLoading,
                        onRestore: {
                            store.dispatch(LoadLocalPurchasesAction(state: store.state))
                            store.dispatch(RestorePurchasesAction())
                    },
                        onLoaded: {
                            store.dispatch(LoadProductsAction())
                    }
                    )
        })
    }
    
    
    
    
    func openSelectCurrencyVC(isSource: Bool = true) {
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
                            
                            let allCurrencies = Currency.allCurrencies
                            vc.props = SelectCurrencyViewController.Props(items: allCurrencies.map { currency in
                                CurrencyItem(currency: currency, rate: rates[currency] ?? 0.0,
                                             onSelect: {
                                                let action: Action = isSource ? SetSourceCurrencyAction(currency: currency) : SetResultCurrencyAction(currency: currency)
                                                store.dispatch(action)
                                })
                                }, selected: selected,
                                   isSourceCurrency: isSource)
        })
        navigationController?.pushViewController(selectVC, animated: true)
    }
    
}
