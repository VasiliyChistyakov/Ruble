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
        NetworkingManager.shared.fetchRates(urlJson: urlJson) { models in
            self.ratesModel = models
            let keys = models.Valute.keys.sorted()
            self.listsOfcurrencies = keys
            print(keys)
            print(keys.count)
        }
    }
    
    func pickerView() -> Int {
        return listsOfcurrencies.count
    }
}
