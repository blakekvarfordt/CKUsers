//
//  WelcomeViewController.swift
//  CKUsers
//
//  Created by Blake kvarfordt on 8/28/19.
//  Copyright © 2019 Blake kvarfordt. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        welcomeLabel.text = "Welcom \(UserController.shared.currentUser?.username ?? "") "
    }


}

