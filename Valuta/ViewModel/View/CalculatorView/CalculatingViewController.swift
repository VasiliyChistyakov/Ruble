//
//  CalculatingViewController.swift
//  Valuta
//
//  Created by Василий  on 27.01.2022.
//

import UIKit

class CalculatingViewController: UIViewController {

    func inputCalculatingСurrency(inputTextField: UITextField!, outputTextField: UITextField, pickedValute: String!, viewModel: ViewModelProtocol! ) {
        guard let inputValute: Int = (Int(inputTextField.text!)), let pickedValute = pickedValute else { return }
        let valueRates: Double = (Double(inputValute) * Double((viewModel.ratesModel?.Valute[pickedValute]!.Value ?? 0)))
        
        guard let valuteNominal =  viewModel.ratesModel?.Valute[pickedValute]?.Nominal! else { return }
        let сalculatingNominal = valueRates / Double(valuteNominal)
        
        outputTextField.text = "\(String(format:"%.2f",сalculatingNominal))"
    }
    
    func outputCalculatingСurrency(inputTextField: UITextField!, outputTextField: UITextField, pickedValute: String!, viewModel: ViewModelProtocol! ) {
        guard let outputValute: Int = (Int(outputTextField.text!)), let pickedValute = pickedValute else { return }
        let valueRates: Double = (Double(outputValute)) / (Double((viewModel.ratesModel?.Valute[pickedValute]!.Value ?? 0)))
        
        guard let valuteNominal =  viewModel.ratesModel?.Valute[pickedValute]?.Nominal! else { return }
        let сalculatingNominal = valueRates * Double(valuteNominal)
        
        inputTextField.text = "\(String(format:"%.2f",сalculatingNominal))"
    }
}
