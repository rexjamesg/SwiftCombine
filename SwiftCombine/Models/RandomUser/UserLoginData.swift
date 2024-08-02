//
//  UserLoginData.swift
//  SwiftCombine
//
//  Created by Yu Li Lin on 2024/7/14.
//

import Foundation

// MARK: - UserLoginData

struct UserLoginData: Codable {
    let uuid: String?
    let username: String?
    let password: String?
    let salt: String?
    let md5: String?
    let sha1: String?
    let sha256: String?
}

extension UserLoginData {
    enum CodingKeys: String, CodingKey {
        case uuid
        case username
        case password
        case salt
        case md5
        case sha1
        case sha256
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        uuid = try container.decodeIfPresent(String.self, forKey: .uuid)
        username = try container.decodeIfPresent(String.self, forKey: .username)
        password = try container.decodeIfPresent(String.self, forKey: .password)
        salt = try container.decodeIfPresent(String.self, forKey: .salt)
        md5 = try container.decodeIfPresent(String.self, forKey: .md5)
        sha1 = try container.decodeIfPresent(String.self, forKey: .sha1)
        sha256 = try container.decodeIfPresent(String.self, forKey: .sha256)
    }
}

// MARK: Hashable, Equatable

extension UserLoginData: Hashable, Equatable {
    static func == (lhs: UserLoginData, rhs: UserLoginData) -> Bool {
        return lhs.uuid == rhs.uuid &&
            lhs.username == rhs.username &&
            lhs.password == rhs.password &&
            lhs.salt == rhs.salt &&
            lhs.md5 == rhs.md5 &&
            lhs.sha1 == rhs.sha1 &&
            lhs.sha256 == rhs.sha256
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
        hasher.combine(username)
        hasher.combine(password)
        hasher.combine(salt)
        hasher.combine(md5)
        hasher.combine(sha1)
        hasher.combine(sha256)
    }
}
