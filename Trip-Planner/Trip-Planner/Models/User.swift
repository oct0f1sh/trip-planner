//
//  User.swift
//  Trip-Planner
//
//  Created by Duncan MacDonald on 10/16/17.
//  Copyright © 2017 Duncan MacDonald. All rights reserved.
//

import Foundation

class User {
    let authHeader: String
    
    init(email: String, password: String) {
        self.authHeader = User.generateBasicAuthHeader(email: email, password: password)
    }
    
    static func generateBasicAuthHeader(email: String, password: String) -> String {
        let loginString = String(format: "%@:%@", email, password)
        let loginData: Data = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString(options: .init(rawValue: 0))
        let authHeaderString = "Basic \(base64LoginString)"
        
        return authHeaderString
    }
}
