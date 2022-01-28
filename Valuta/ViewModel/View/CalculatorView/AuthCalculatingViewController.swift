//
//  AuthCalculatingViewController.swift
//  Valuta
//
//  Created by Василий  on 27.01.2022.
//

import UIKit
import Firebase

class AuthCalculatingViewController: UIViewController {
    
    func fetchFirebaseUserName(complitionHandler: @escaping (String)-> Void) {
        let ref = Database.database().reference()
        guard let userID = Auth.auth().currentUser?.uid else { return }
        ref.child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in

            let value = snapshot.value as? NSDictionary
            let username = value?["name"] as? String ?? ""
            complitionHandler(username)
            print(username)
         
        }) { (error) in
            print(error.localizedDescription)
        }
    }

}
