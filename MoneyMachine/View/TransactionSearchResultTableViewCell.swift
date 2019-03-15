//
//  TransactionSearchResultTableViewCell.swift
//  MoneyMachine
//
//  Created by Yun Qian on 3/15/19.
//  Copyright © 2019 Yun Qian. All rights reserved.
//

import UIKit

class TransactionSearchResultTableViewCell: UITableViewCell {
    
    @IBOutlet var userLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var tagLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    func bindData(viewModel: TransactionSearchResultCellViewModel) {
        userLabel.text = viewModel.userId
        amountLabel.text = viewModel.amount
        tagLabel.text = viewModel.tagName
        descriptionLabel.text = viewModel.description
        dateLabel.text = viewModel.date
    }
    
}
