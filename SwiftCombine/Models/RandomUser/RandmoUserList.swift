//
//  RandmoUserList.swift
//  SwiftCombine
//
//  Created by Yu Li Lin on 2024/7/14.
//

import Foundation

// MARK: - RandmoUserList

struct RandmoUserList: Codable, Hashable {
    let results: [RandomUser]?
    let info: UserInfo?
}

extension RandmoUserList {
    enum CodingKeys: String, CodingKey {
        case results
        case info
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        results = try container.decodeIfPresent([RandomUser].self, forKey: .results)
        info = try container.decodeIfPresent(UserInfo.self, forKey: .info)
    }
}

