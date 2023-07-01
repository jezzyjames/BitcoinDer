//
//  HistoryViewController.swift
//  BitcoinConverter
//
//  Created by TasitS on 1/7/2566 BE.
//

import UIKit

class HistoryViewController: UIViewController {

    @IBOutlet var historyView: HistoryView!
    
    var historyViewModel = HistoryViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        historyView.setupView(currencyCode: historyViewModel.currencyCode, currencyDescription: historyViewModel.currencyDescription)
        
        historyView.historyRateTableView.delegate = self
        historyView.historyRateTableView.dataSource = self
    }
    
}

// TableViewDelegate, TableViewDataSource

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyViewModel.rateHistoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = historyView.historyRateTableView.dequeueReusableCell(withIdentifier: "rateHistoryTableViewCell", for: indexPath)
        
        cell.textLabel?.text = historyViewModel.rateHistoryList[indexPath.row].date.dateFormat
        cell.detailTextLabel?.text = historyViewModel.currencySymbol.html2String + String(format: "%.2f", historyViewModel.rateHistoryList[indexPath.row].rate)
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20.0)
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 16.0)
        
        return cell
    }
    
    
}
