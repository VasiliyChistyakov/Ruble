//
//  ViewController.swift
//  Valuta
//
//  Created by Чистяков Василий Александрович on 15.08.2021.
//

import UIKit
import Combine
import Firebase

class ViewController: UIViewController {
    
    var pickedValute: String!
    
    var inputObserver: AnyCancellable?
    var outputObserver: AnyCancellable?
    var calculatingViewController: CalculatingViewController?
    
    var authCalculatingViewController: AuthCalculatingViewController?
    
    private var viewModel: ViewModelProtocol! {
        didSet {
            self.viewModel.appendData()
            DispatchQueue.main.async {
                self.pickerView.reloadAllComponents()
            }
            
            NetworkingManager.shared.fetchRates(urlJson: urlJson) { model in
                let data = model.Valute
                if !data.isEmpty {
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
    @IBOutlet weak var nameButtonItem: UIBarButtonItem!
    
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
        
        calculatingViewController = CalculatingViewController()
        authCalculatingViewController = AuthCalculatingViewController()
    
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
                self.calculatingViewController?.inputCalculatingСurrency(inputTextField: self.inputTextField,
                                              outputTextField: self.outputTextField,
                                                                         pickedValute: self.pickedValute, viewModel: self.viewModel)
            })
     
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
                self.calculatingViewController?.outputCalculatingСurrency(inputTextField: self.inputTextField,
                                               outputTextField: self.outputTextField,
                                                                          pickedValute: self.pickedValute, viewModel: self.viewModel)
            })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.authCalculatingViewController?.fetchFirebaseUserName(complitionHandler: { username in
            self.nameButtonItem.title = "Привет, \(username)!"
        })
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        guard let email = Auth.auth().currentUser?.email else { return }
        let alert = UIAlertController(title: "Профиль", message: "\(email)", preferredStyle: .actionSheet)
        let exitAction = UIAlertAction(title: "Выход", style: .default) { _ in
            do {
                try Auth.auth().signOut()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in }
        
        alert.addAction(okAction)
        alert.addAction(exitAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func tapAction(_ sender: Any) {
        inputTextField.resignFirstResponder()
        outputTextField.resignFirstResponder()
        print(viewModel.listsOfcurrencies)
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
        
        self.calculatingViewController?.inputCalculatingСurrency(inputTextField: self.inputTextField,
                                      outputTextField: self.outputTextField,
                                                                 pickedValute: self.pickedValute, viewModel: viewModel )
        
        self.calculatingViewController?.outputCalculatingСurrency(inputTextField: self.inputTextField,
                                       outputTextField: self.outputTextField,
                                                                  pickedValute: self.pickedValute, viewModel: viewModel)
    }
}

