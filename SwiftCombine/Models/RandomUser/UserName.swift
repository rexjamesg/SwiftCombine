//
//  UserName.swift
//  SwiftCombine
//
//  Created by Yu Li Lin on 2024/7/14.
//

import Foundation

struct UserName:Codable {
    let title:String
    let first:String
    let last:String
}

extension UserName: Hashable, Equatable {
    static func == (lhs: UserName, rhs: UserName) -> Bool {
        return lhs.title == rhs.title &&
        lhs.first == rhs.first &&
        lhs.last == rhs.last
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(first)
        hasher.combine(last)
    }
}
