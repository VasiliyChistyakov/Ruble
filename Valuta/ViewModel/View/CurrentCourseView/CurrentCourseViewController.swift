//
//  CurrentCourseViewController.swift
//  Valuta
//
//  Created by Василий  on 02.01.2022.
//

import UIKit

class CurrentCourseViewController: UIViewController {
    
    var defaults: UserDefaults!
    
    private var viewModel: ViewModelProtocol! {
        didSet {
                self.viewModel.appendData()
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        defaults = UserDefaults.standard
        
        viewModel = ViewModel()
    }
    
    @IBAction func tapSettings(_ sender: Any) {
        print("Tap")
    }
}

extension CurrentCourseViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.pickerView()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CurrentCourseCollectionViewCell
        
        cell.upImage.isHidden = false
        cell.downImage.isHidden = false
        
        let differenceIndecator = defaults.bool(forKey: "indecator")
        let nameIndecator = defaults.bool(forKey: "nameValute")
        
        let keys = viewModel.listsOfcurrencies[indexPath.row]
        
        cell.nameValutaLabel.isHidden = nameIndecator
        cell.nameValutaLabel.text = viewModel.ratesModel?.Valute[keys]?.Name
        
        cell.charCodeLabel.text = viewModel.ratesModel?.Valute[keys]?.CharCode
        
        let nominal = Double(viewModel.ratesModel?.Valute[keys]!.Nominal ?? 1)
        
        let value = viewModel.ratesModel?.Valute[keys]!.Value ?? 0
        let previous = viewModel.ratesModel?.Valute[keys]!.Previous ?? 0
        
        let nominalValue = value / nominal
        let nominalPrevious = previous / nominal
        
        let difference = nominalValue - nominalPrevious
        
        if previous < value {
            cell.valueLabel.textColor = .red
            cell.previousLabel.textColor = .green
            cell.downImage.isHidden = true
        } else {
            cell.valueLabel.textColor = .green
            cell.previousLabel.textColor = .red
            cell.upImage.isHidden = true
        }
        
        cell.valueLabel.text = "\(String(format: "%.1f" ,nominalValue)) ₽"
        
        if differenceIndecator == false {
            cell.previousLabel.text = "\(String(format: "%.1f" ,nominalPrevious)) ₽"
        } else {
            cell.previousLabel.text = "\(String(format: "%.2f" ,difference)) ₽"
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "CurrentVC", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CurrentVC" {
            let vc = segue.destination as! CurrentSecondViewController
            let indexPath = sender as! IndexPath
            
            let keys = viewModel.listsOfcurrencies[indexPath.row]
            let valuta = viewModel.ratesModel?.Valute[keys]
            
            vc.valuta = valuta
        }
    }
}
