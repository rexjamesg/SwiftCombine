//
//  UserStreet.swift
//  SwiftCombine
//
//  Created by Yu Li Lin on 2024/7/14.
//

import Foundation

// MARK: - UserStreet

struct UserStreet: Codable {
    let number: Int?
    let name: String?
}

extension UserStreet {
    enum CodingKeys: String, CodingKey {
        case number
        case name
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        number = try container.decodeIfPresent(Int.self, forKey: .number)
        name = try container.decodeIfPresent(String.self, forKey: .name)
    }
}

// MARK: Hashable, Equatable

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
