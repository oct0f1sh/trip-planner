//
//  LoginService.swift
//  Trip-Planner
//
//  Created by Duncan MacDonald on 10/16/17.
//  Copyright © 2017 Duncan MacDonald. All rights reserved.
//

import Foundation

class NetworkService {
    static var loggedInUser: User!
    static let usersURL = URL(string: "https://aqueous-waters-43306.herokuapp.com/users/")!
    static let tripsURL = URL(string: "https://aqueous-waters-43306.herokuapp.com/trips/")!
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
                NetworkService.loggedInUser = user
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
                NetworkService.loggedInUser = user
                completion(httpResponse.statusCode)
            }
        }
        task.resume()
    }
    
    static func getTrips(user: User = NetworkService.loggedInUser, completion: @escaping ([Trip]?) -> Void) {
        var request = NetworkService.tripsRequest
        request.httpMethod = "GET"
        let session = URLSession.shared
        
        request.addValue(user.authHeader, forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                print("Error while getting trips")
                completion(nil)
                return
            }
            
            if let data = data {
                let trips = try? JSONDecoder().decode([Trip].self, from: data)
                completion(trips)
            }
        }
        task.resume()
    }
    
    static func putTrip(trip: Trip, user: User = NetworkService.loggedInUser, completion: @escaping (Int?) -> Void) {
        let url = URL(string: "https://aqueous-waters-43306.herokuapp.com/trips/\(trip.id!)")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        let session = URLSession.shared
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        
        
        let trip = try! encoder.encode(trip)
        
        request.addValue(user.authHeader, forHTTPHeaderField: "Authorization")
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = trip
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                print("Error PUTting trip")
                completion(nil)
                return
            }
            
            if let response = response {
                let response = response as! HTTPURLResponse
                print("Trip PUT response code: \(response)")
                completion(response.statusCode)
            }
        }
        task.resume()
    }
}


















