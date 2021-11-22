//
//  RandmoUserList.swift
//  SwiftCombine
//
//  Created by Yu Li Lin on 2024/7/14.
//

import Foundation

struct RandmoUserList:Codable {
    let results:[RandomUser]
    let info:UserInfo
}

extension RandmoUserList: Hashable, Equatable {
    static func == (lhs: RandmoUserList, rhs: RandmoUserList) -> Bool {
        return lhs.results == rhs.results &&
        lhs.info == rhs.info
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(results)
        hasher.combine(info)
    }
}
