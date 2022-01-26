//
//  SettingsViewController.swift
//  Valuta
//
//  Created by Василий  on 09.01.2022.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var differenceIndecator: Bool!
    var nameValuteIndecator: Bool!
    var defaults: UserDefaults!
    
    static var shared = SettingsViewController()
    
    @IBOutlet weak var differenceLabelSwitch: UISwitch!
    
    @IBOutlet weak var nameLabelSwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.defaults = UserDefaults.standard
        
        self.differenceIndecator = defaults.bool(forKey: "indecator")
        self.nameValuteIndecator = defaults.bool(forKey: "nameValute")
        
        self.differenceLabelSwitch.isOn = defaults.bool(forKey: "indecator")
        self.nameLabelSwitch.isOn = defaults.bool(forKey: "nameValute")
    }
    
    @IBAction func previosSwitchAction(_ sender: UISwitch) {
        if sender.isOn {
            self.differenceIndecator = true
            defaults.set(differenceIndecator, forKey: "indecator")
        } else {
            self.differenceIndecator = false
            defaults.set(differenceIndecator, forKey: "indecator")
        }
    }
    
    @IBAction func nameSwitchAction(_ sender: UISwitch) {
        if sender.isOn {
            self.nameValuteIndecator = true
            defaults.set(nameValuteIndecator, forKey: "nameValute")
        } else {
            self.nameValuteIndecator = false
            defaults.set(nameValuteIndecator, forKey: "nameValute")
        }
    }
}
