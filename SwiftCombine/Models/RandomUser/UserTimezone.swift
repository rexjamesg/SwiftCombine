//
//  UserTimezone.swift
//  SwiftCombine
//
//  Created by Yu Li Lin on 2024/7/14.
//

import Foundation

// MARK: - UserTimezone

struct UserTimezone: Codable {
    let offset: String?
    let description: String?
}

extension UserTimezone {
    enum CodingKeys: String, CodingKey {
        case offset
        case description
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        offset = try container.decodeIfPresent(String.self, forKey: .offset)
        description = try container.decodeIfPresent(String.self, forKey: .description)
    }
}

// MARK: Hashable, Equatable

extension UserTimezone: Hashable, Equatable {
    static func == (lhs: UserTimezone, rhs: UserTimezone) -> Bool {
        return lhs.offset == rhs.offset &&
            lhs.description == rhs.description
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(offset)
        hasher.combine(description)
    }
}
