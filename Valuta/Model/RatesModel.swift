//
//  RatesModel.swift
//  Valuta
//
//  Created by Чистяков Василий Александрович on 15.08.2021.
//

import Foundation

struct RatesModel: Codable {
    let Date: String
    let PreviousDate: String
    let PreviousURL: String
    let Timestamp: String
    let Valute: [String: Valute]
}

struct Valute: Codable{
    let ID: String
    let NumCode: String
    let CharCode: String
    let Nominal: Int?
    let Name: String
    let Value: Double
    let Previous: Double
}

