//
//  TransactionSearchResultsTableViewController.swift
//  MoneyMachine
//
//  Created by Yun Qian on 3/15/19.
//  Copyright © 2019 Yun Qian. All rights reserved.
//

import UIKit

class TransactionSearchResultsTableViewController: UITableViewController {
    
    @IBOutlet var headerView: UIView!
    var viewModel: TransactionSearchResultViewModel
    
    required init?(coder aDecoder: NSCoder) {
        self.viewModel = TransactionSearchResultViewModel([])
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Transactions"
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - Table view data source, data delegate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionSearchResultTableViewCell", for: indexPath) as! TransactionSearchResultTableViewCell
        cell.bindData(viewModel: viewModel.transactionResultCellViewModel(for: indexPath.row))
        
        return cell
    }
    
}
