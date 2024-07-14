//
//  UserInfo.swift
//  SwiftCombine
//
//  Created by Yu Li Lin on 2024/7/14.
//

import Foundation

struct UserInfo:Codable {
    let seed: String
    let results: Int
    let page: Int
    let version: String
}

extension UserInfo: Hashable, Equatable {
    static func == (lhs: UserInfo, rhs: UserInfo) -> Bool {
        return lhs.seed == rhs.seed &&
        lhs.results == rhs.results &&
        lhs.page == rhs.page &&
        lhs.version == rhs.version
        
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(seed)
        hasher.combine(results)
        hasher.combine(page)
        hasher.combine(version)
    }
}
