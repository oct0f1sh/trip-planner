//
//  User+Encodable.swift
//  Trip-Planner
//
//  Created by Duncan MacDonald on 10/17/17.
//  Copyright © 2017 Duncan MacDonald. All rights reserved.
//

import Foundation

extension User: Encodable {
    func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: UserKeys.self)
        try values.encode(email, forKey: .email)
        try values.encode(password, forKey: .password)
    }
}
