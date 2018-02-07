//
//  SelectCurrencyViewController.swift
//  HowMuch
//
//  Created by Максим Казаков on 07/02/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import UIKit
import ReSwift

struct CurrencyItem: Equatable {
    static func ==(lhs: CurrencyItem, rhs: CurrencyItem) -> Bool {
        return lhs.currency == rhs.currency && lhs.rate == rhs.rate
    }
    
    let currency: Currency
    let rate: Float
    let onSelect: () -> Void
}


class SelectCurrencyViewController: UITableViewController {
    struct Props {
        let items: [CurrencyItem]
        let selectedIdx: Int
        static let zero = Props(items: [], selectedIdx: 0)
    }
    
    
    var props: Props = .zero {
        didSet {
            if props.items != oldValue.items {
                tableView.reloadData()
            }
            if !initialized {
                initialized = true
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    self.tableView.selectRow(at: IndexPath(row: self.props.selectedIdx, section: 0), animated: true, scrollPosition: .middle)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clearsSelectionOnViewWillAppear = false
    }
    
    private let changeSourceAction: Bool
    private var initialized: Bool = false
    
    init(style: UITableViewStyle, changeSourceAction: Bool) {
        self.changeSourceAction = changeSourceAction
        super.init(style: style)        
    }
    
    convenience init(changeSourceAction: Bool) {
        self.init(style: .plain, changeSourceAction: changeSourceAction)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(CurrencyViewCell.self, forCellReuseIdentifier: CurrencyViewCell.identifier)
        tableView.rowHeight = 50
        configureNavigation()
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        store.unsubscribe(self)
    }
    
    
    func configureNavigation() {
        title = "Select currency"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "closeIcon"), style: .plain, target: self, action: #selector(close))
    }
    
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return props.items.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        props.items[indexPath.row].onSelect()
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyViewCell.identifier) as! CurrencyViewCell
        cell.setup(currency: props.items[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
}


extension SelectCurrencyViewController: StoreSubscriber {
    func connect(to store: Store<AppState>) {
        store.subscribe(self)
    }
    
    
    func newState(state: AppState) {
        let rates = state.currencyRates.rates
        let settings = state.settings
        let selected = self.changeSourceAction ? settings.sourceCurrency : settings.resultCurrency
        let selectedIdx = Currency.allCurrencies.index(of: selected) ?? 0
        props = Props(items: Currency.allCurrencies.map { currency in
            CurrencyItem(currency: currency, rate: rates[currency] ?? 0.0,
                         onSelect: {
                            let action: Action = self.changeSourceAction ? SetSourceCurrencyAction(currency: currency) : SetResultCurrencyAction(currency: currency)
                            store.dispatch(action)
            })
        }, selectedIdx: selectedIdx)
    }
}
