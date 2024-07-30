//
//  UserInfo.swift
//  SwiftCombine
//
//  Created by Yu Li Lin on 2024/7/14.
//

import Foundation

// MARK: - UserInfo

struct UserInfo: Codable, Hashable {
    let seed: String?
    let results: Int?
    let page: Int?
    let version: String?
}

extension UserInfo {
    enum CodingKeys: String, CodingKey {
        case seed
        case results
        case page
        case version
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        seed = try container.decodeIfPresent(String.self, forKey: .seed)
        results = try container.decodeIfPresent(Int.self, forKey: .results)
        page = try container.decodeIfPresent(Int.self, forKey: .page)
        version = try container.decodeIfPresent(String.self, forKey: .version)
    }
}
