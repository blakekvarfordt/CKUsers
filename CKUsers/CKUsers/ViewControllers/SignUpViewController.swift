//
//  SignUpViewController.swift
//  CKUsers
//
//  Created by Blake kvarfordt on 8/28/19.
//  Copyright © 2019 Blake kvarfordt. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var petNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserController.shared.fetchCurrentUser { (success) in
            if success {
                print("yeah buddy")
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUserPosted), name: .userCreated, object: nil)
    }
    
    

    @IBAction func signUpButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text, let username = usernameTextField.text, let petName = petNameTextField.text else { return }
        
        
        UserController.shared.createUserWith(email: email, username: username, petName: petName) { (success) in
            if success {
                print("successful!")
            }
        }
    }
    
    @objc func handleUserPosted() {
        guard UserController.shared.currentUser != nil else {
            return
        }
        self.performSegue(withIdentifier: "ToWlcomeVC", sender: self)
    }
}
