//
//  TransactionReportTableViewCell.swift
//  MoneyMachine
//
//  Created by Yun Qian on 3/17/19.
//  Copyright © 2019 Yun Qian. All rights reserved.
//

import UIKit

class TransactionReportTableViewCell: UITableViewCell {

    @IBOutlet var userLabel: UILabel!
    @IBOutlet var totalSpendingLabel: UILabel!
    @IBOutlet var totalSavingsLabel: UILabel!
    @IBOutlet var tagsLabel: UILabel!
    
    func bindData(viewModel: TransactionResportRowViewModel) {
        userLabel.text = viewModel.userId
        totalSpendingLabel.text = viewModel.totalSpending
        totalSavingsLabel.text = viewModel.totalSavings
        tagsLabel.text = viewModel.tags
    }

}
