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


class SelectCurrencyViewController: UITableViewController, UISearchResultsUpdating, SimpleStoreSubscriber, UISearchBarDelegate {
        
    var onStateChanged: ((AppState) -> Void)!
    
    struct Props {
        let items: [CurrencyItem]
        let selected: Currency?
//        let filteredItems: [CurrencyItem]
//        let selectedFilterIdx: Int
//        let onSearchTextChanged: ((String) -> Void)?
        
        static let zero = Props(items: [],
                                selected: nil
//                                ,filteredItems: [],
//                                selectedFilterIdx: -1,
//                                onSearchTextChanged: nil
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
    
    
    var searchController: UISearchController!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clearsSelectionOnViewWillAppear = false
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        forceSelectCell()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(CurrencyViewCell.self, forCellReuseIdentifier: CurrencyViewCell.identifier)
        tableView.rowHeight = 50
        configureNavigation()
        navigationItem.largeTitleDisplayMode = .always
        
        searchController = UISearchController(searchResultsController: nil)
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
    
    
    override func viewDidDisappear(_ animated: Bool) {
        store.unsubscribe(self)
    }
    
    
    func configureNavigation() {
        title = "Select currency"
    }
    
    
    @objc func swipeLeftAction(gesture: UIGestureRecognizer) {
        // TODO popViewController
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering() ? filteredItems.count : props.items.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let visibleCurrencies = isFiltering() ? filteredItems : props.items
        visibleCurrencies[indexPath.row].onSelect()
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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

