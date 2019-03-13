//
//  HomeViewController.swift
//  MoneyMachine
//
//  Created by Yun Qian on 3/12/19.
//  Copyright © 2019 Yun Qian. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //TODO: all strings could use localized string
        title = "Money Machine"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "saveMoney",
            let transactionViewController = segue.destination as? TransactionViewController {
            transactionViewController.mondeyTransactionType = .save
        }
        
        super .prepare(for: segue, sender: sender)
    }

}
