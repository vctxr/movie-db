//
//  String+Extensions.swift
//  MovieDB
//
//  Created by Victor Samuel Cuaca on 15/12/20.
//

import Foundation

extension Int {
    
    var currencyFormat: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 0
        if let str = formatter.string(for: self) {
            return str
        }
        return "--"
    }
}
