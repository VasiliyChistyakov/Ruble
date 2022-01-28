//
//  CurrentSecondViewController.swift
//  Valuta
//
//  Created by Василий  on 03.01.2022.
//

import UIKit
import Charts

class CurrentSecondViewController: UIViewController, ChartViewDelegate {
    
    var valuta: Valute?
    var lineChart = LineChartView()
    var valueResult: Double?
    var previousResult: Double?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var charCodeLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var differenceLabel: UILabel!
    @IBOutlet weak var upLabel: UIImageView!
    @IBOutlet weak var downLabel: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lineChart.delegate = self
        
        self.upLabel.isHidden = false
        self.downLabel.isHidden = false
        
        lineChart = LineChartView()
        
        fetchSeсondCurrency()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    
        lineChart.frame = CGRect(x: 0, y: 0, width: 350, height: 200)
        lineChart.center = view.center
        view.addSubview(lineChart)
        
        guard let previousResult = previousResult else { return }
        guard let valueResult = valueResult else { return }
        
        let set = LineChartDataSet(entries: [ ChartDataEntry(x: previousResult,
                                                             y: previousResult),
                                              ChartDataEntry(x: valueResult,
                                                             y: valueResult)
                                            ])
        
        set.colors = ChartColorTemplates.joyful()
        let date = LineChartData(dataSet: set)
        lineChart.data = date
    }
    
    func fetchSeсondCurrency() {
        guard let nominal = valuta?.Nominal else { return }
        guard let value = valuta?.Value else { return }
        guard let previous = valuta?.Previous else { return }
      
        let resultValue = value / Double(nominal)
        self.valueResult = resultValue
        
        let resultPrevious = previous / Double(nominal)
        self.previousResult = resultPrevious
        
        let difference = resultValue - resultPrevious
        self.valueLabel.text = "\(String(format: "%.2f",resultValue)) ₽"
        
        if value > previous {
            self.differenceLabel.textColor = .red
            self.downLabel.isHidden = true
        } else {
            self.differenceLabel.textColor = .green
            self.upLabel.isHidden = true
        }
        
        self.differenceLabel.text = "\(String(format: "%.2f" ,difference)) ₽"
        self.charCodeLabel.text = valuta?.CharCode
        self.nameLabel.text = valuta?.Name
    }
}

