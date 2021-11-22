//
//  UserStreet.swift
//  SwiftCombine
//
//  Created by Yu Li Lin on 2024/7/14.
//

import Foundation

struct UserStreet:Codable {
    let number:Int
    let name:String
}

extension UserStreet: Hashable, Equatable {
    static func == (lhs: UserStreet, rhs: UserStreet) -> Bool {
        return lhs.number == rhs.number &&
        lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(number)
        hasher.combine(name)
    }
}
