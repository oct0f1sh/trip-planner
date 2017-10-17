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
        if emailTextField.text == "" {
            print("Email text field empty")
            return
        }
        if passwordTextField.text == "" {
            print("Email text field empty")
            return
        }
        
        let usr = User(email: emailTextField.text!, password: passwordTextField.text!)
        
        // create new user
        if isNewUser.isOn {
            NetworkService.createUser(user: usr, completion: { (code) in
                if let code = code {
                    switch code {
                    case 201:
                        print("Successfully created new user")
                        DispatchQueue.main.async(execute: {
                            self.performSegue(withIdentifier: "toTripsView", sender: self)
                        })
                    case 401:
                        DispatchQueue.main.async(execute: {
                            self.showAlert(title: "Error", message: "Email already in use.", actionText: "Ok")
                        })
                    default:
                        print("An unknown error occurred while trying to create a user")
                    }
                }
            })
        // log in with existing user
        } else {
            NetworkService.authenticateUser(user: usr) { (code) in
                if let code = code {
                    switch code {
                    case 200:
                        print("Logged in successfully")
                        DispatchQueue.main.async(execute: {
                            self.performSegue(withIdentifier: "toTripsView", sender: self)
                        })
                    default:
                        DispatchQueue.main.async(execute: {
                            self.showAlert(title: "Error", message: "Error logging in.", actionText: "Ok")
                        })
                    }
                } else {
                    DispatchQueue.main.async(execute: {
                        self.showAlert(title: "ERROR", message: "Error logging in. Please fill out the email and password fields completely.", actionText: "Fine")
                    })
                }
            }
        }
    }
}
