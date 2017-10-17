//
//  LoginService.swift
//  Trip-Planner
//
//  Created by Duncan MacDonald on 10/16/17.
//  Copyright © 2017 Duncan MacDonald. All rights reserved.
//

import Foundation

class NetworkService {
    static let usersURL = URL(string: "http://127.0.0.1:5000/users/")!
    static let tripsURL = URL(string: "http://127.0.0.1:5000/trips/")!
    static let tripsRequest = URLRequest(url: NetworkService.tripsURL)
    static let usersRequest = URLRequest(url: NetworkService.usersURL)
    
    static func authenticateUser(user: User, completion: @escaping (Int?) -> Void) {
        var request = URLRequest(url: NetworkService.usersURL)
        request.addValue(user.authHeader, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                print("Error with authenticating user: \(error?.localizedDescription ?? "")")
                completion(nil)
                return
            }
            
            if let response = response {
                let httpResponse = response as! HTTPURLResponse
                print("User auth HTTP Response code: \(httpResponse.statusCode)")
                completion(httpResponse.statusCode)
            }
        }
        task.resume()
    }
    
    static func createUser(user: User, completion: @escaping (Int?) -> Void) {
        var request = NetworkService.usersRequest
        request.httpMethod = "POST"
        let session = URLSession.shared
        let encoder = JSONEncoder()
        
        request.httpBody = try! encoder.encode(user)
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                print("Error with creating user: \(error?.localizedDescription ?? "")")
                completion(nil)
                return
            }
            
            if let response = response {
                let httpResponse = response as! HTTPURLResponse
                print("User create HTTP Response code: \(httpResponse.statusCode)")
                completion(httpResponse.statusCode)
            }
        }
        task.resume()
    }
}
