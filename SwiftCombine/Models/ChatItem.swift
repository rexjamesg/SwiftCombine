//
//  ChatItem.swift
//  SwiftCombine
//
//  Created by Yu Li Lin on 2025/2/17.
//

import Foundation

// MARK: - ChatItem

struct ChatItem: Codable, Hashable {
    let name: String
    let content: String
    let dateTime: Date
}
