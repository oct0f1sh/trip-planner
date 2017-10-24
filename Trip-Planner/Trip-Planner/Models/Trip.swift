//
//  Trip.swift
//  Trip-Planner
//
//  Created by Duncan MacDonald on 10/16/17.
//  Copyright © 2017 Duncan MacDonald. All rights reserved.
//

import Foundation
import UIKit

struct Trip {
    let name: String
    let owner: String
    var isCompleted: Bool
    var waypoints: [String]
    var id: String? = nil
    
    init(name: String, owner: User, isCompleted: Bool = false) {
        self.name = name
        self.isCompleted = isCompleted
        self.waypoints = []
        self.owner = owner.email
    }
    
    init(id: String? = nil, name: String, email: String, isCompleted: Bool, waypoints: [String]) {
        self.id = id
        self.name = name
        self.owner = email
        self.isCompleted = isCompleted
        self.waypoints = waypoints
    }
    
    enum TripKeys: String, CodingKey {
        case name
        case owner
        case isCompleted = "is_completed"
        case waypoints
        case id
    }
}
