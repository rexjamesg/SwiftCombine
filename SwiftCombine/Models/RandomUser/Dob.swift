//
//  Dob.swift
//  SwiftCombine
//
//  Created by Yu Li Lin on 2024/7/14.
//

import Foundation

struct Dob:Codable {
    let date: String
    let age: Int
}

extension Dob: Hashable, Equatable {
    static func == (lhs: Dob, rhs: Dob) -> Bool {
        return lhs.date == rhs.date &&
        lhs.age == rhs.age
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(date)
        hasher.combine(age)
    }
}
