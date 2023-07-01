//
//  CurrencyModel.swift
//  BitcoinConverter
//
//  Created by TasitS on 1/7/2566 BE.
//

import Foundation

struct CurrencyData: Codable {
    let time: Time
    let bpi: BPI
}

struct Time: Codable {
    let updated: String
    let updatedISO: String
    let updateduk: String
}

struct BPI: Codable {
    let USD: Currency
    let GBP: Currency
    let EUR: Currency
}

struct Currency: Codable {
    let code: String
    let symbol: String
    let rate: String
    let description: String
    let rate_float: Double
}
