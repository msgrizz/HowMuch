//
//  PurchasesViewController.swift
//  HowMuch
//
//  Created by Максим Казаков on 22/02/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import UIKit

struct ProductViewModel {
    let name: String
    let price: String
    let type: ProductType
    var state: ProductState
    let onBuy: (() -> Void)?    
    
    static func ==(lhs: ProductViewModel, rhs: ProductViewModel) -> Bool {
        return lhs.name == rhs.name
            && lhs.price == rhs.price
            && lhs.state == rhs.state
            && lhs.type == rhs.type
    }
    static let zero = ProductViewModel(name: "", price: "", type: .forever, state: .disabled, onBuy: nil)
}



final class PurchasesViewController: UITableViewController, SimpleStoreSubscriber {
    var onStateChanged: ((PurchasesViewController, PurchaseState) -> Void)!
    
    struct Props {
        let products: [ProductViewModel]
        let isLoading: Bool
        let onRestore: (() -> Void)?
        let onLoaded: (() -> Void)?
        static let zero = Props(products: [], isLoading: false, onRestore: nil, onLoaded: nil)
    }
    
    var props: Props = .zero {
        didSet {
            guard isViewLoaded else { return }
            if props.isLoading {
                loadingIndicator.isHidden = false
            } else {
                loadingIndicator.isHidden = true
            }
            tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(PurchaseViewCell.self, forCellReuseIdentifier: PurchaseViewCell.identifier)
        tableView.allowsSelection = false
        configureNavigation()
        navigationItem.largeTitleDisplayMode = .always
        
        loadingIndicator.center = tableView.center
        loadingIndicator.isHidden = true
        
        navigationController?.view.addSubview(self.loadingIndicator)
        props.onLoaded?()
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return props.isLoading ? 0 : sections.count
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        loadingIndicator.removeFromSuperview()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        switch section {
        case .forever:
            forever = props.products.filter({ $0.type == .forever})
            return forever.count
        case .subscriptions:
            subscriptions = props.products.filter({ $0.type == .subscription(term: 0)})
            return subscriptions.count
        }
    }
    
    var forever = [ProductViewModel]()
    var subscriptions = [ProductViewModel]()
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: PurchaseViewCell.identifier) as! PurchaseViewCell
        switch section {
        case .forever:
            let forever = self.forever[indexPath.row]
            cell.set(viewModel: forever) { forever.onBuy?() }
        case .subscriptions:
            let subscription = subscriptions[indexPath.row]
            cell.set(viewModel: subscription) { subscription.onBuy?() }
        }
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].description
    }
    
    
    
    enum Section: CustomStringConvertible {
        case forever
        case subscriptions
        
        var description: String {
            switch self {
            case .forever:
                return "Forever".localized
            case .subscriptions:
                return "Subscriptions".localized
            }
        }
    }
    
    private let sections: [Section] = [.subscriptions, .forever]
    
    
    private func configureNavigation() {
        title = "Purchases".localized
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Restore".localized, style: .plain, target: self, action: #selector(onRestoreAction))
    }
    
    
    @objc private func onRestoreAction() {
        props.onRestore?()
    }
    
    private let loadingIndicator = LoadingIndicatorView()
}
