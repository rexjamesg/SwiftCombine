//
//  Registered.swift
//  SwiftCombine
//
//  Created by Yu Li Lin on 2024/7/14.
//

import Foundation

struct Registered:Codable {
    let date: String
    let age: Int
}

extension Registered: Hashable, Equatable {
    static func == (lhs: Registered, rhs: Registered) -> Bool {
        return lhs.date == rhs.date &&
        lhs.age == rhs.age
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(date)
        hasher.combine(age)
    }
}
