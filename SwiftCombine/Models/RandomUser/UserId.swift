//
//  UserId.swift
//  SwiftCombine
//
//  Created by Yu Li Lin on 2024/7/14.
//

import Foundation

// MARK: - UserId

struct UserId: Codable, Hashable {
    let name: String?
}

extension UserId {
    enum CodingKeys: String, CodingKey {
        case name
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name)
    }
}

