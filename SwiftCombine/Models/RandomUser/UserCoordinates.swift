//
//  UserCoordinates.swift
//  SwiftCombine
//
//  Created by Yu Li Lin on 2024/7/14.
//

import Foundation

// MARK: - UserCoordinates

struct UserCoordinates: Codable {
    let latitude: String?
    let longitude: String?
}

extension UserCoordinates {
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        latitude = try container.decodeIfPresent(String.self, forKey: .latitude)
        longitude = try container.decodeIfPresent(String.self, forKey: .longitude)
    }
}

// MARK: Hashable, Equatable

extension UserCoordinates: Hashable, Equatable {
    static func == (lhs: UserCoordinates, rhs: UserCoordinates) -> Bool {
        return lhs.latitude == rhs.latitude &&
            lhs.longitude == rhs.longitude
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(latitude)
        hasher.combine(longitude)
    }
}
