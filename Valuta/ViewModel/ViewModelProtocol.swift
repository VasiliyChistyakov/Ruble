//
//  ViewModelProtocol.swift
//  Valuta
//
//  Created by Василий  on 01.01.2022.
//

import Foundation

protocol ViewModelProtocol {
    
    var listsOfcurrencies: [String] { get } 
    var ratesModel: RatesModel? { get }
    
    func appendData()
    func pickerView() -> Int
}
