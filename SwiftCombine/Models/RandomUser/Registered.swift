//
//  Registered.swift
//  SwiftCombine
//
//  Created by Yu Li Lin on 2024/7/14.
//

import Foundation

// MARK: - Registered

struct Registered: Codable, Hashable {
    let date: String?
    let age: Int?
}

extension Registered {
    enum CodingKeys: String, CodingKey {
        case date
        case age
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        date = try container.decodeIfPresent(String.self, forKey: .date)
        age = try container.decodeIfPresent(Int.self, forKey: .age)
    }
}
