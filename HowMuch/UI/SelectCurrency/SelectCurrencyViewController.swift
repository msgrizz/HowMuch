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


final class SelectCurrencyViewController: UITableViewController, UISearchResultsUpdating, SimpleStoreSubscriber, UISearchBarDelegate {        
    var onStateChanged: ((SelectCurrencyViewController, AppState) -> Void)!
    
    struct Props {
        let items: [CurrencyItem]
        let selected: Currency?
        let isSourceCurrency: Bool
        static let zero = Props(items: [],
                                selected: nil,
                                isSourceCurrency: true
        )
    }
    
    
    var props: Props = .zero {
        didSet {
            if props.items != oldValue.items {
                tableView.reloadData()
            }
        }
    }
    
    private var filteredItems = [CurrencyItem]()
    
    private func filter(text: String) {
        let lowcasedText = text.lowercased()
        filteredItems = props.items.filter { $0.currency.name.lowercased().contains(lowcasedText) ||  $0.currency.shortName.lowercased().contains(lowcasedText)}
        tableView.reloadData()
        forceSelectCell()
    }
    
    private func isFiltering() -> Bool {
        return searchController.isActive && !(searchController.searchBar.text ?? "").isEmpty
    }
    
    private func forceSelectCell() {
        if let selected = props.selected {
            let visibleCurrencies = isFiltering() ? filteredItems : props.items
            if let selectedIdx = visibleCurrencies.index(where: { $0.currency == selected }) {
                tableView.selectRow(at: IndexPath(row: selectedIdx, section: 0), animated: true, scrollPosition: .middle)
            }
        }
    }
    
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clearsSelectionOnViewWillAppear = false
        navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = nil
        searchController.searchBar.setBackgroundImage(nil, for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        forceSelectCell()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(CurrencyViewCell.self, forCellReuseIdentifier: CurrencyViewCell.identifier)
        tableView.register(ButtonViewCell.self, forCellReuseIdentifier: ButtonViewCell.identifier)
        tableView.rowHeight = 50
        configureNavigation()
        navigationItem.largeTitleDisplayMode = .never
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.returnKeyType = .done
        searchController.searchBar.delegate = self
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
        
        
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeftAction))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
    }
    
    
    
    
    func configureNavigation() {
        title = "SelectCurrency".localized
    }
    
    
    
    @objc func swipeLeftAction(gesture: UIGestureRecognizer) {
        // TODO popViewController
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredItems.count
        } else {
            return props.items.count
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == props.items.count {
            openPurchases()
            return
        }
        let visibleCurrencies = isFiltering() ? filteredItems : props.items
        visibleCurrencies[indexPath.row].onSelect()
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == props.items.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: ButtonViewCell.identifier) as! ButtonViewCell
            cell.selectionStyle = .none
            cell.setup(title: "UnlockAllCurrencies".localized)
            cell.setup(background: Colors.accent1, textColor: UIColor.white)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyViewCell.identifier) as! CurrencyViewCell
        let item: CurrencyItem
        if isFiltering() {
            item = filteredItems[indexPath.row]
        } else {
            item = props.items[indexPath.row]
        }
        cell.setup(currency: item)
        cell.selectionStyle = .none
        return cell
    }
    
    
    //MARK: -UISearchResultsUpdating
    public func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filter(text: searchBar.text ?? "")
    }
    
    
    
    //MARK: -UISearchBarDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = false
    }
}

