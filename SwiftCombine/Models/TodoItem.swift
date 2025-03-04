//
//  TodoItem.swift
//  SwiftCombine
//
//  Created by Yu Li Lin on 2025/2/17.
//

import Foundation

// 定義待辦事項的模型，必須符合 Identifiable 協議以方便 List 使用
struct TodoItem: Identifiable {
    let id = UUID()
    var title: String
    var isCompleted: Bool = false
}
