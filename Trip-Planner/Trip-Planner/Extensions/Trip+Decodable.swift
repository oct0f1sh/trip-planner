//
//  Trip+Decodable.swift
//  Trip-Planner
//
//  Created by Duncan MacDonald on 10/17/17.
//  Copyright © 2017 Duncan MacDonald. All rights reserved.
//

import Foundation
import UIKit

extension Trip: Decodable {
    enum Keys: String, CodingKey {
        case name
        case owner
        case isCompleted = "is_completed"
        case waypoints
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        let name = try container.decode(String.self, forKey: .name)
        let owner = try container.decode(String.self, forKey: .owner)
        let isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
        let waypoints = try container.decode([String].self, forKey: .waypoints)
        
        self.init(name: name, email: owner, isCompleted: isCompleted, waypoints: waypoints)
    }
}
