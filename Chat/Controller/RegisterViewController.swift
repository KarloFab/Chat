//
//  RegisterViewController.swift
//  Chat
//
//  Created by Karlo Fabijanić on 29.11.2021..
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func registerPressed(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let err = error {
                    print(err)
                } else {
                    self.performSegue(withIdentifier: "RegisterToChat", sender: self)
                }
            }
        }
    }
    
}

