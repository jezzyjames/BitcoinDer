//
//  CurrencyModel.swift
//  BitcoinConverter
//
//  Created by TasitS on 1/7/2566 BE.
//

import Foundation

struct CurrencyModel {
    let code: String
    let description: String
    let rates: [Rate]
    let symbol: String
}

struct Rate {
    let date: String
    let rate: Double
}
