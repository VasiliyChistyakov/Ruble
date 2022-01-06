//
//  CurrentCourseViewController.swift
//  Valuta
//
//  Created by Василий  on 02.01.2022.
//

import UIKit

class CurrentCourseViewController: UIViewController {
    
    
    private var viewModel: ViewModelProtocol! {
        didSet {
            viewModel.appendData()
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
        
        viewModel = ViewModel()
    }
}

extension CurrentCourseViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        arrayPicked.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CurrentCourseCollectionViewCell
        
        cell.upImage.isHidden = false
        cell.downImage.isHidden = false
        
        let keys = viewModel.listsOfcurrencies[indexPath.row]
        cell.nameValutaLabel.text = viewModel.ratesModel?.Valute[keys]?.Name
        
        cell.charCodeLabel.text = viewModel.ratesModel?.Valute[keys]?.CharCode
        
        let nominal = Double(viewModel.ratesModel?.Valute[keys]!.Nominal ?? 1)
        
        let value = viewModel.ratesModel?.Valute[keys]!.Value ?? 0
        let previous = viewModel.ratesModel?.Valute[keys]!.Previous ?? 0
        
        let nominalValue = value / nominal
        let nominalPrevious = previous / nominal
        
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
        cell.previousLabel.text = "\(String(format: "%.1f" ,nominalPrevious)) ₽"
        
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
