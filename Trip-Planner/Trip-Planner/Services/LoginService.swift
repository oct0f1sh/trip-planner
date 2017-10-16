//
//  LoginService.swift
//  Trip-Planner
//
//  Created by Duncan MacDonald on 10/16/17.
//  Copyright © 2017 Duncan MacDonald. All rights reserved.
//

import Foundation

class LoginService {
    static func loginUser(email: String, password: String) {
        let user = User(email: email, password: password)
        
        let url = URL(string: "127.0.0.1:5000/users/")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession.shared
        
        
    }
}
