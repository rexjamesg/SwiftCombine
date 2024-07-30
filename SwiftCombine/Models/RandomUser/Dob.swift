//
//  Dob.swift
//  SwiftCombine
//
//  Created by Yu Li Lin on 2024/7/14.
//

import Foundation

// MARK: - Dob

struct Dob: Codable {
    let date: String?
    let age: Int?
}

extension Dob {
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

// MARK: Hashable, Equatable

extension Dob: Hashable, Equatable {
    static func == (lhs: Dob, rhs: Dob) -> Bool {
        return lhs.date == rhs.date &&
            lhs.age == rhs.age
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(date)
        hasher.combine(age)
    }
}
