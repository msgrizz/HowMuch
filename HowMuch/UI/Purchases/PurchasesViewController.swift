//
//  PurchasesViewController.swift
//  HowMuch
//
//  Created by Максим Казаков on 22/02/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import UIKit

enum PurchaseState: Equatable {

    case notBought
    case disabled
    case bought(expired: Date?)
    
    static func ==(lhs: PurchaseState, rhs: PurchaseState) -> Bool {
        switch (lhs, rhs) {
        case (.notBought, .notBought):
            return true
        case (.disabled, .disabled):
            return true
        case (.bought, .bought):
            return true
        default:
            return false
        }
    }
}


struct PurchaseViewModel {
    let name: String
    let price: String
    let state: PurchaseState
    
    static let zero = PurchaseViewModel(name: "", price: "", state: .disabled)
}



final class PurchasesViewController: UITableViewController, SimpleStoreSubscriber {
    var onStateChanged: ((PurchasesViewController, AppState) -> Void)!
    
    struct Props {
        struct PurchaseItem {
            let viewModel: PurchaseViewModel
            let onBuy: (() -> Void)?
            static let zero = PurchaseItem(viewModel: PurchaseViewModel.zero, onBuy: nil)
        }
        
        let subscriptions: [PurchaseItem]
        let forever: PurchaseItem
        let isLoading: Bool
        let onRestore: (() -> Void)?
        static let zero = Props(subscriptions: [], forever: .zero, isLoading: false, onRestore: nil)
    }
    
    var props: Props = .zero {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(PurchaseViewCell.self, forCellReuseIdentifier: PurchaseViewCell.identifier)
        tableView.rowHeight = 50
        configureNavigation()
        navigationItem.largeTitleDisplayMode = .always
    }
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        switch section {
        case .forever:
            return 1
        case .subscriptions:
            return props.subscriptions.count
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: PurchaseViewCell.identifier) as! PurchaseViewCell
        switch section {
        case .forever:
            let forever = props.forever
            cell.set(viewModel: props.forever.viewModel) { forever.onBuy?() }
        case .subscriptions:
            let subscription = props.subscriptions[indexPath.row]
            cell.set(viewModel: subscription.viewModel) { subscription.onBuy?() }
        }
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].rawValue
    }
    
    
    
    enum Section: String {
        case forever = "Forever"
        case subscriptions = "Subscriptions"
    }
    
    private let sections: [Section] = [.forever, .subscriptions]
    
    
    private func configureNavigation() {
        title = "Purchases"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Restore", style: .plain, target: self, action: #selector(onRestoreAction))
    }
    
    
    @objc private func onRestoreAction() {
        props.onRestore?()
    }
}
