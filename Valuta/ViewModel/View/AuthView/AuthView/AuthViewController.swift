//
//  AuthViewController.swift
//  Valuta
//
//  Created by Василий  on 26.01.2022.
//

import UIKit
import Firebase

class AuthViewController: UIViewController {
    
    var signup: Bool = true {
        willSet {
            if newValue {
                titleLabel.text = "Регистрация"
                nameTextField.isHidden = false
                enterButton.setTitle("Войти", for: .normal)
                questionLabel.isHidden = false
            } else {
                titleLabel.text = "Вход"
                nameTextField.isHidden = true
                enterButton.setTitle("Регистрация", for: .normal)
                questionLabel.isHidden = true
                
            }
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var enterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        mailTextField.delegate = self
        passwordTextField.delegate = self
        
    }
    
    @IBAction func switchLogin(_ sender: UIButton) {
        signup = !signup
    }
    
    
    
    func showAllert() {
        let allert = UIAlertController(title: "Ошибка", message: "Заполните все поля", preferredStyle: .alert)
        allert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(allert, animated: true, completion: nil )
    }
    
}

extension AuthViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let name = nameTextField.text!
        let email = mailTextField.text!
        let password = passwordTextField.text!
        
        if (signup) {
            if(!name.isEmpty && !email.isEmpty && !password.isEmpty) {
                Auth.auth().createUser(withEmail: email, password: password) { result, error in
                    if error == nil {
                        if let result = result {
                            print(result.user.uid)
                            let ref = Database.database().reference().child("users")
                            ref.child(result.user.uid).updateChildValues(["name": name, "email": email])
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            } else {
                showAllert()
            }
        } else {
            if(!email.isEmpty && !password.isEmpty) {
                Auth.auth().signIn(withEmail: email, password: password) { result, error in
                    if error == nil {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
                
            } else {
                showAllert()
            }
        }
        return true
    }
}
