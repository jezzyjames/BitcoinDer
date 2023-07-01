//
//  StringExtension.swift
//  BitcoinConverter
//
//  Created by TasitS on 1/7/2566 BE.
//

import Foundation

extension String {
    var data: Data { .init(utf8) }
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print(error)
            return nil
        }
    }
    var html2String: String { html2AttributedString?.string ?? "" }
    var unicodes: [UInt32] { unicodeScalars.map(\.value) }
    
    var toDate: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
//                        2023-07-01T07:49:00+00:00
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let newDate = dateFormatter.date(from: self) ?? Date()
        
        return newDate
    }
    
    var dateFormat: String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd MMM yyyy, HH:mm"

        if let date = dateFormatterGet.date(from: self) {
            let dateString = dateFormatterPrint.string(from: date)
            return dateString
        } else {
           return ""
        }
    }
}
