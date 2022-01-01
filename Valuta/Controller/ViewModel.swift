//
//  ViewModel.swift
//  Valuta
//
//  Created by Василий  on 01.01.2022.
//

import Foundation

class ViewModel: ViewModelProtocol {
    
    var listsOfcurrencies: [String] = []
    var ratesModel: RatesModel?
    
    func appendData() {
        NetworkingManager.shared.fetchRates { models in
            self.ratesModel = models
            let keys = models.Valute.keys.sorted()
            self.listsOfcurrencies = keys
        }
    }
    
    func pickerView() -> Int {
        return listsOfcurrencies.count
    }
}
