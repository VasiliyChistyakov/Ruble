//
//  ViewController.swift
//  Valuta
//
//  Created by Чистяков Василий Александрович on 15.08.2021.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    var pickedValute: String!
    
    var inputObserver: AnyCancellable?
    var outputObserver: AnyCancellable?
    
    private var viewModel: ViewModelProtocol! {
        didSet {
            self.viewModel.appendData()
            DispatchQueue.main.async {
                self.pickerView.reloadAllComponents()
            }
            /// Придумать как это сдкелать из mvvm
            NetworkingManager.shared.fetchRates(urlJson: urlJson) { data in
                if data.Valute.isEmpty {
                    print("Нет значений")
                } else {
                    DispatchQueue.main.async {
                        self.activityIndicator.isHidden = true
                        self.activityIndicator.stopAnimating()
                        
                        self.pickerView.isHidden = false
                        self.topTextLabel.isHidden = false
                        self.inputTextField.isHidden = false
                        self.outputTextField.isHidden = false
                    }
                }
            }
        }
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var outputTextField: UITextField!
    @IBOutlet weak var topTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.isHidden = true
        topTextLabel.isHidden = true
        inputTextField.isHidden = true
        outputTextField.isHidden = true
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        viewModel = ViewModel()
        
        /// Рефакторинг
        inputObserver = NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: inputTextField)
            .map {$0.object as? UITextField}
            .compactMap { $0?.text }
            .map { str -> Bool in
                if let number = Double(str) {
                    return number > 0
                } else {
                    return false
                }
            }
            .sink(receiveValue: { value in
                self.inputCalculatingСurrency(inputTextField: self.inputTextField,
                                              outputTextField: self.outputTextField,
                                              pickedValute: self.pickedValute)
            })
        /// Рефакторинг
        outputObserver = NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: outputTextField)
            .map {$0.object as? UITextField}
            .compactMap { $0?.text }
            .map { str -> Bool in
                if let number = Double(str) {
                    return number > 0
                } else {
                    return false
                }
            }
            .sink(receiveValue: { value in
                self.outputCalculatingСurrency(inputTextField: self.inputTextField,
                                               outputTextField: self.outputTextField,
                                               pickedValute: self.pickedValute)
            })
    }
    
    @IBAction func tapAction(_ sender: Any) {
        inputTextField.resignFirstResponder()
        outputTextField.resignFirstResponder()
        print(viewModel.listsOfcurrencies)
    }
    
    func inputCalculatingСurrency(inputTextField: UITextField!, outputTextField: UITextField, pickedValute: String!) {
        guard let inputValute: Int = (Int(inputTextField.text!)), let pickedValute = pickedValute else { return }
        let valueRates: Double = (Double(inputValute) * Double((viewModel.ratesModel?.Valute[pickedValute]!.Value ?? 0)))
        
        guard let valuteNominal =  viewModel.ratesModel?.Valute[pickedValute]?.Nominal! else { return }
        let сalculatingNominal = valueRates / Double(valuteNominal)
        
        outputTextField.text = "\(String(format:"%.2f",сalculatingNominal))"
    }
    
    func outputCalculatingСurrency(inputTextField: UITextField!, outputTextField: UITextField, pickedValute: String!) {
        guard let outputValute: Int = (Int(outputTextField.text!)), let pickedValute = pickedValute else { return }
        let valueRates: Double = (Double(outputValute)) / (Double((viewModel.ratesModel?.Valute[pickedValute]!.Value ?? 0)))
        
        guard let valuteNominal =  viewModel.ratesModel?.Valute[pickedValute]?.Nominal! else { return }
        let сalculatingNominal = valueRates * Double(valuteNominal)
        
        inputTextField.text = "\(String(format:"%.2f",сalculatingNominal))"
    }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.pickerView()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.listsOfcurrencies[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.pickedValute = self.viewModel.listsOfcurrencies[row]
        self.topTextLabel.text = self.viewModel.ratesModel?.Valute[self.pickedValute]?.Name
        self.inputTextField.placeholder = self.viewModel.listsOfcurrencies[row]
        
        self.inputCalculatingСurrency(inputTextField: self.inputTextField,
                                      outputTextField: self.outputTextField,
                                      pickedValute: self.pickedValute)
        
        self.outputCalculatingСurrency(inputTextField: self.inputTextField,
                                       outputTextField: self.outputTextField,
                                       pickedValute: self.pickedValute)
    }
}

