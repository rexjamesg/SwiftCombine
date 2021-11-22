//
//  UserPicture.swift
//  SwiftCombine
//
//  Created by Yu Li Lin on 2024/7/14.
//

import Foundation

struct UserPicture:Codable {
    let large: String
    let medium: String
    let thumbnail: String
}

extension UserPicture: Hashable, Equatable {
    static func == (lhs: UserPicture, rhs: UserPicture) -> Bool {
        return lhs.large == rhs.large &&
        lhs.medium == rhs.medium &&
        lhs.thumbnail == rhs.thumbnail
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(large)
        hasher.combine(medium)
        hasher.combine(thumbnail)
    }
}
