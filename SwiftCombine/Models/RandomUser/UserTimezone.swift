//
//  UserTimezone.swift
//  SwiftCombine
//
//  Created by Yu Li Lin on 2024/7/14.
//

import Foundation

struct UserTimezone:Codable {
    let offset: String
    let description: String
}

extension UserTimezone: Hashable, Equatable {
    static func == (lhs: UserTimezone, rhs: UserTimezone) -> Bool {
        return lhs.offset == rhs.offset &&
        lhs.description == rhs.description
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(offset)
        hasher.combine(description)
    }
}
