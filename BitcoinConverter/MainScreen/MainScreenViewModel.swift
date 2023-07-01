//
//  MainScreenViewModel.swift
//  BitcoinConverter
//
//  Created by TasitS on 30/6/2566 BE.
//

import Foundation
import RealmSwift

protocol MainScreenViewModelDelegate {
    func didUpdateCurrencyList()
    func didSelectedCurrencyChanged(selectedCurrency: String)
    func didConverted(bitcoinAmount: Double)
}

class MainScreenViewModel {
    
    var delegate: MainScreenViewModelDelegate?
    var currencyList: [CurrencyModel]? {
        didSet {
            delegate?.didUpdateCurrencyList()
        }
    }
    var timer = Timer()
    var selectedCurrency: String? {
        didSet {
            if let selectedCurrency = selectedCurrency {
                delegate?.didSelectedCurrencyChanged(selectedCurrency: selectedCurrency)
            }
        }
    }
    
    func startAutoCurrencyFetch() {
        fetchData()
        timer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true, block: { timer in
            self.fetchData()
        })

    }
    
    private func saveCurrencyData(newCurrencyData: Currency, newDateString: String) {
        let realm = try! Realm()
        
        let allCurrencyRealm = realm.objects(CurrencyRealm.self)
        let newRate = HistoryRates(rate: newCurrencyData.rate_float, date: newDateString)
        
        // Check if data in Realm exist
        if let currencyRealm = allCurrencyRealm.first(where: { $0.code == newCurrencyData.code}) {
            // Update new price rate only
            do {
                try realm.write {
                
                    let existHistoryRates = currencyRealm.historyRates.contains(where: { $0.date == newDateString })
                    
                    if !existHistoryRates {
                        currencyRealm.historyRates.append(newRate)
                    }
                }
            } catch {
                print("Realm failed to update!")
            }
        } else {
            // add new Currency data
            let newCurrencyRealm = CurrencyRealm(code: newCurrencyData.code, currencyDescription: newCurrencyData.description, symbol: newCurrencyData.symbol)
            newCurrencyRealm.historyRates.append(newRate)
            
            do {
                try realm.write {
                    realm.add(newCurrencyRealm, update: .all)
                }
            } catch {
                print("Realm failed to write!")
            }
        }
        print(allCurrencyRealm)
    }
    
    private func fetchData() {
        DataRequester.sharedInstance.performRequest(Constants.currencyRequestURL) { data, error in
            if let error = error {
                print(error)
            } else {
                if let currencyData = data {
                    if let currencyData = self.parseJSON(currencyData) {
                        
                        let newDateString = currencyData.time.updatedISO
                        let usdData = currencyData.bpi.USD
                        let gbpData = currencyData.bpi.GBP
                        let eurData = currencyData.bpi.EUR
                        
                        self.saveCurrencyData(newCurrencyData: usdData, newDateString: newDateString)
                        self.saveCurrencyData(newCurrencyData: gbpData, newDateString: newDateString)
                        self.saveCurrencyData(newCurrencyData: eurData, newDateString: newDateString)
                        
                        let realm = try! Realm()
                        let allCurrencyRealm = realm.objects(CurrencyRealm.self)
                        
                        var newCurrencyList: [CurrencyModel] = []
                        for currency in allCurrencyRealm {
                            let historyRates = currency.historyRates
                            var rates: [Rate] = []
                            for historyRate in historyRates {
                                let rate = Rate(date: historyRate.date, rate: historyRate.rate)
                                rates.append(rate)
                            }
                            let newCurrencyModel = CurrencyModel(code: currency.code, description: currency.currencyDescription, rates: rates, symbol: currency.symbol)
                            
                            newCurrencyList.append(newCurrencyModel)
                            
                        }
                        
                        self.currencyList = newCurrencyList
                    }
                    
                }
            }
            
        }
    }

    private func parseJSON(_ currencyData: Data) -> CurrencyData?{
        let decoder = JSONDecoder()
        do {
            //Store weatherData as a WeatherData object type into decodeData
            let currencyData = try decoder.decode(CurrencyData.self, from: currencyData)
            return currencyData

        } catch {
            print("Failed to passJSON")
            return nil
        }
    }
    
    func convertCurrencyToBitcoin(moneyAmount: String) {
        let selectedCurrencyModel = currencyList?.first(where: { $0.code == self.selectedCurrency })
        
        if let moneyDouble = Double(moneyAmount), let lastestRate = selectedCurrencyModel?.rates.last?.rate {
            let bitcoinAmount = moneyDouble / lastestRate
            delegate?.didConverted(bitcoinAmount: bitcoinAmount)
        }
    }
    
}
