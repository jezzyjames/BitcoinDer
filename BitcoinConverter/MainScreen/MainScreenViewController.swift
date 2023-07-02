//
//  MainScreenViewController.swift
//  BitcoinConverter
//
//  Created by TasitS on 30/6/2566 BE.
//

import UIKit
import DropDown

class MainScreenViewController: UIViewController {
    
    @IBOutlet var mainScreenView: MainScreenView!
    
    let dropDown = DropDown()
    
    let mainScreenViewModel = MainScreenViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainScreenView.setupView()
        
        mainScreenView.currencyTableView.dataSource = self
        mainScreenView.currencyTableView.delegate = self
        
        mainScreenViewModel.delegate = self
        mainScreenViewModel.startAutoCurrencyFetch()
        
        mainScreenView.inputTextField.delegate = self
    }
    

    
    @IBAction func showDropDownAction(_ sender: UIButton) {
        dropDown.show()
    }
    
    @IBAction func convertToBitcoin(_ sender: UIButton) {
        if let inputMoney = mainScreenView.inputTextField.text {
            mainScreenViewModel.convertCurrencyToBitcoin(moneyAmount: inputMoney)
        }
    }
    
    func setupDropDown() {
        
        dropDown.anchorView = mainScreenView.dropDownView
        
        let currencyList = mainScreenViewModel.currencyList ?? []
        var dropDownDataSource: [String] = []
        for currency in currencyList {
            let currencyCode = currency.code
            dropDownDataSource.append(currencyCode)
        }
        
        dropDown.dataSource = dropDownDataSource
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            mainScreenViewModel.selectedCurrency = item
        }
        
    }
}

// UITextFieldDelegate

extension MainScreenViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        let arrayOfString = newString.components(separatedBy: ".")

        if arrayOfString.count > 2 {
            return false
        }
        return true
    }
}

// TableView

extension MainScreenViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainScreenViewModel.currencyList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mainScreenView.currencyTableView.dequeueReusableCell(withIdentifier: "currencyTableViewCell", for: indexPath)
        
        let currencyCode = mainScreenViewModel.currencyList?[indexPath.row].code ?? ""
        let currencySymbol = mainScreenViewModel.currencyList?[indexPath.row].symbol ?? ""
        let currencyRate = mainScreenViewModel.currencyList?[indexPath.row].rates.last?.rate ?? 0.0
        
        cell.textLabel?.text = currencyCode
        cell.detailTextLabel?.text = currencySymbol.html2String + String(format: "%.2f", currencyRate)
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20.0)
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 16.0)
        
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let historyViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "historyViewController") as! HistoryViewController
        
        let currencyCode = mainScreenViewModel.currencyList?[indexPath.row].code ?? ""
        let currencySymbol = mainScreenViewModel.currencyList?[indexPath.row].symbol ?? ""
        let currencyDescription = mainScreenViewModel.currencyList?[indexPath.row].description ?? ""
        let rateHistoryList = mainScreenViewModel.currencyList?[indexPath.row].rates.reversed() ?? []

        historyViewController.historyViewModel.currencyCode = currencyCode
        historyViewController.historyViewModel.currencySymbol = currencySymbol
        historyViewController.historyViewModel.currencyDescription = currencyDescription
        historyViewController.historyViewModel.rateHistoryList = rateHistoryList
        self.present(historyViewController, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}

// MainScreenViewModelDelegate

extension MainScreenViewController: MainScreenViewModelDelegate {
    func didUpdateCurrencyList() {
        print("reloaded!")
        
        DispatchQueue.main.async { [self] in
            if mainScreenViewModel.selectedCurrency == nil {
                mainScreenViewModel.selectedCurrency = mainScreenViewModel.currencyList?.first?.code
            }
            
            self.mainScreenView.currencyTableView.reloadData()
            self.setupDropDown()
        }
    }
    
    func didSelectedCurrencyChanged(selectedCurrency: String) {
        mainScreenView.setDropDownText(text: selectedCurrency)
        mainScreenView.resetInputTextField()
        mainScreenView.resetBitcoinAmountLabelText()
    }
    
    func didConverted(bitcoinAmount: Double) {
        mainScreenView.setBitcoinAmountLabelText(bitcoinAmount: bitcoinAmount)
    }
}
