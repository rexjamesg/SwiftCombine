//
//  UserName.swift
//  SwiftCombine
//
//  Created by Yu Li Lin on 2024/7/14.
//

import Foundation

// MARK: - UserName

struct UserName: Codable {
    let title: String?
    let first: String?
    let last: String?
}

extension UserName {
    enum CodingKeys: String, CodingKey {
        case title
        case first
        case last
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        first = try container.decodeIfPresent(String.self, forKey: .first)
        last = try container.decodeIfPresent(String.self, forKey: .last)
    }
}

// MARK: Hashable, Equatable

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
