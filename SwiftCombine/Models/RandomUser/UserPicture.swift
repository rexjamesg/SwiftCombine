//
//  UserPicture.swift
//  SwiftCombine
//
//  Created by Yu Li Lin on 2024/7/14.
//

import Foundation

// MARK: - UserPicture

struct UserPicture: Codable, Hashable {
    let large: String?
    let medium: String?
    let thumbnail: String?
}

extension UserPicture {
    enum CodingKeys: String, CodingKey {
        case large
        case medium
        case thumbnail
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        large = try container.decodeIfPresent(String.self, forKey: .large)
        medium = try container.decodeIfPresent(String.self, forKey: .medium)
        thumbnail = try container.decodeIfPresent(String.self, forKey: .thumbnail)
    }
}
