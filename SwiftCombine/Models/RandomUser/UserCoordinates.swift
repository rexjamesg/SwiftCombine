//
//  UserCoordinates.swift
//  SwiftCombine
//
//  Created by Yu Li Lin on 2024/7/14.
//

import Foundation

struct UserCoordinates:Codable {
    let latitude:String
    let longitude:String
}

extension UserCoordinates: Hashable, Equatable {
    static func == (lhs: UserCoordinates, rhs: UserCoordinates) -> Bool {
        return lhs.latitude == rhs.latitude &&
        lhs.longitude == rhs.longitude
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(latitude)
        hasher.combine(longitude)
    }
}
