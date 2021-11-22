//
//  UserId.swift
//  SwiftCombine
//
//  Created by Yu Li Lin on 2024/7/14.
//

import Foundation

struct UserId:Codable {
    let name:String
}

extension UserId: Hashable, Equatable {
    static func == (lhs: UserId, rhs: UserId) -> Bool {
        return lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
