//
//  ForgotPasswordViewController.swift
//  Valuta
//
//  Created by Василий  on 26.01.2022.
//

import UIKit
import Firebase

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var mailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func forgotPassword(_ sender: UIButton) {
        let email = mailTextField.text!
        if (!email.isEmpty) {
            Auth.auth().sendPasswordReset(withEmail: email) { (error) in
                if error == nil {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    @IBAction func backVc(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
