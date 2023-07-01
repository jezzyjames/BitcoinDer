//
//  MainScreenView.swift
//  BitcoinConverter
//
//  Created by TasitS on 1/7/2566 BE.
//

import DropDown
import UIKit

class MainScreenView: UIView {

    @IBOutlet weak var inputTextField: UITextField!

    @IBOutlet weak var convertButton: UIButton!
    @IBOutlet weak var dropDownView: UIView!
    @IBOutlet weak var dropDownLabel: UILabel!
    @IBOutlet weak var bitcoinAmountView: UIView!
    @IBOutlet weak var bitcoinAmountLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var currencyTableView: UITableView!
    
    func setupView() {
        self.backgroundColor = .systemGroupedBackground
        bitcoinAmountView.layer.cornerRadius = 6.0
        convertButton.layer.cornerRadius = 6.0
    }
    
    func setDropDownText(text: String) {
        dropDownLabel.text = text
    }
    
    func setBitcoinAmountLabelText(bitcoinAmount: Double) {
        bitcoinAmountLabel.text = String(format: "%.8f", bitcoinAmount)
    }
    
    func resetInputTextField() {
        inputTextField.text = ""
    }
    
    func resetBitcoinAmountLabelText() {
        bitcoinAmountLabel.text = "-"
    }
}
