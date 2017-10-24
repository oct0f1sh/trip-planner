//
//  Trip+Encodable.swift
//  Trip-Planner
//
//  Created by Duncan MacDonald on 10/20/17.
//  Copyright © 2017 Duncan MacDonald. All rights reserved.
//

import Foundation

extension Trip: Encodable {
    func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: Keys.self)
        var waypointsContainer = values.nestedUnkeyedContainer(forKey: .waypoints)
        try values.encode(name, forKey: .name)
        try values.encode(owner, forKey: .owner)
        try values.encode(isCompleted, forKey: .isCompleted)
        try waypointsContainer.encode(waypoints)
    }
}
