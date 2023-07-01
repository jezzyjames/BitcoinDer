//
//  CurrencyRealm.swift
//  BitcoinConverter
//
//  Created by TasitS on 1/7/2566 BE.
//

import Foundation
import RealmSwift

class CurrencyRealm: Object {
//    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var code: String = ""
    @Persisted var currencyDescription: String = ""
    @Persisted var symbol: String = ""
    @Persisted var historyRates = List<HistoryRates>()
    
    convenience init(code: String, currencyDescription: String, symbol: String) {
        self.init()
        self.code = code
        self.currencyDescription = currencyDescription
        self.symbol = symbol
    }
    
    override static func primaryKey() -> String {
        return "code"
    }
}

class HistoryRates: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var rate: Double = 0.0
    @Persisted var date: String = ""
    
    convenience init(rate: Double, date: String) {
        self.init()
        self.rate = rate
        self.date = date
    }
}

