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
    
    init(name: String, owner: User, isCompleted: Bool = false) {
        self.name = name
        self.isCompleted = completed
        self.waypoints = []
        self.owner = owner.email
    }
    
    init(name: String, owner: User, isCompleted: Bool, waypoints: [String]) {
        self.name = name
        self.owner = owner
        self.isCompleted = isCompleted
        self.waypoints = waypoints
    }
}
