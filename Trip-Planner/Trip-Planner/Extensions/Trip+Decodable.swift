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
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        let idConntainer = try container.nestedContainer(keyedBy: IdKey.self, forKey: .id)
        let id = try idConntainer.decodeIfPresent(String.self, forKey: .oid)
        let name = try container.decode(String.self, forKey: .name)
        let owner = try container.decode(String.self, forKey: .owner)
        let isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
        let waypoints = try container.decode([String].self, forKey: .waypoints)
        
        if let id = id {
            self.init(id: id, name: name, email: owner, isCompleted: isCompleted, waypoints: waypoints)
        } else {
            self.init(name: name, email: owner, isCompleted: isCompleted, waypoints: waypoints)
        }
    }
}
