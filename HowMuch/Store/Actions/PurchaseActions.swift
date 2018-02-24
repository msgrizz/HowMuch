//
//  PurchaseActions.swift
//  HowMuch
//
//  Created by Максим Казаков on 23/02/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import ReSwift
import StoreKit


/// Загрузить продукты из стора
struct LoadProductsAction: Action {}

/// Продукты успешно загружены
struct SuccessLoadedProductsAction: Action {
    let products: [SKProduct]
}

/// Ошибка загрузки продуктов
struct FailureLoadedProductsAction: Action {
    let error: String
}
    
    
    
/// Восставноить покупки
struct RestorePurchasesAction: Action {}

/// Купить продукт
struct BuyProductAction: Action {
    let product: SKProduct
}

/// Покупка успешно куплена
struct SuccessPaymentAction: Action {
    let purchaseInfo: PurchaseInfo    
}

/// Ошибка при оплате покупки
struct FailurePaymentAction: Action {}



/// Загрузить из локальной базы информацию о покупках
struct LoadPurchasedAction: Action {
    let purchaseInfos: [PurchaseInfo]
}


/// Проверить актуальность покупок
struct CheckExpiredPurchasesAction: Action {
    
}
