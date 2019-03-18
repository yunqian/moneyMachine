//
//  TransactionReportViewController.swift
//  MoneyMachine
//
//  Created by Yun Qian on 3/12/19.
//  Copyright © 2019 Yun Qian. All rights reserved.
//

import UIKit

enum TransactionPeriodType: Int {
    case yearly, monthly, weekly, daily
}

class TransactionReportViewController: UIViewController {

    @IBOutlet var reportSegmentedControl: UISegmentedControl!
    @IBOutlet var tableView: UITableView!
    var viewModel: TransactionReportProtocol
    
    required init?(coder aDecoder: NSCoder) {
        self.viewModel = TransactionReportViewModel()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Report"
        tableView.tableFooterView = UIView()
        
        updateReportDate(at: 0)
    }

    @IBAction func segmentedControlValueChanged(_ sender: Any) {
        updateReportDate(at: reportSegmentedControl.selectedSegmentIndex)
    }
    
    private func updateReportDate(at index: Int){
        viewModel.updatePeriodModel(at: index)
        tableView.reloadData()
    }

}

// MARK: - Table view data source, data delegate

extension TransactionReportViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.reportSectionTitle(section: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numbersOfReportSection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rowNumbersOfReportSection(section: section) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row > 0 else {
          return  tableView.dequeueReusableCell(withIdentifier: "TransactionReportHeaderCell", for: indexPath)
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionReportTableViewCell",
                                                 for: indexPath)
        if let cell = cell as? TransactionReportTableViewCell {
            let cellIndexPath = IndexPath.init(row: indexPath.row - 1, section: indexPath.section)
            cell.bindData(viewModel: viewModel.reportRowViewModel(at: cellIndexPath))
        }
        
        return cell
    }
    
}
