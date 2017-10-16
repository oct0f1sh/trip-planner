//
//  ViewController.swift
//  Trip-Planner
//
//  Created by Duncan MacDonald on 10/16/17.
//  Copyright © 2017 Duncan MacDonald. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var isNewUser: UISwitch!
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        let usr = User(email: emailTextField.text!, password: passwordTextField.text!)
        print(usr.authHeader)
    }
}

