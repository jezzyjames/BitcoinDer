//
//  HistoryView.swift
//  BitcoinConverter
//
//  Created by TasitS on 1/7/2566 BE.
//

import UIKit

class HistoryView: UIView {

    @IBOutlet weak var currencyCodeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var historyRateTableView: UITableView!
    
    func setupView(currencyCode: String, currencyDescription: String) {
        currencyCodeLabel.text = currencyCode
        descriptionLabel.text = currencyDescription
    }

}
